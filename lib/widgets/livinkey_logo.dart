import 'dart:math' as math;
import 'package:flutter/material.dart';

/// ------------------------------------------------------------------
/// Exact brand green, sampled directly from your logo file (#92C24A).
/// ------------------------------------------------------------------
const Color kLivinkeyGreen = Color(0xFF92C24A);
const Color kLivinkeyBlack = Color(0xFF000000);
const Color kLivinkeyWhite = Color(0xFFFFFFFF);

/// The two image layers below were cropped from your original logo file
/// so they share the exact same canvas size/coordinates:
///   - base layer  = "Livinke" + roofline + "A COMPLETE HOME" (key removed)
///   - key layer   = only the key, everything else transparent
const String kLogoBaseAsset = 'assets/images/livinkey_base_white.png';
// IMPORTANT: this is a NEW, tightly-cropped asset — not the original
// livinkey_key_white.png. The original key PNG is the full 1231x487 canvas
// with the key drawn far over on the right (everything else transparent),
// so it can't be scaled directly into a small moving box. This cropped
// version contains ONLY the key artwork, padded 4px on each side.
// Add it to your project at assets/images/livinkey_key_white.png
// and register it in pubspec.yaml's assets list.
const String kLogoKeyAsset = 'assets/images/livinkey_key_white_without_ring.png';
// UPDATED ASSET: this file has had its ring + dot pixels erased (made
// transparent) — it now shows only the arms, shaft, and teeth. The ring
// and dot are supplied separately by kLogoRingDotAsset below and are
// drawn back in by the animation, landing in the exact gap this file
// leaves behind. Replace your existing asset with this updated version.

// This is the piece that bounces — and, since the file above no longer
// contains it, it's also the ONLY place the ring + dot are drawn at all.
// It's a tight crop of just the two connected pixel clusters that make up
// the ring (the hole, which reads as a "white ring" against the white
// background) and the little dot floating inside that hole. Found by
// running connected-component analysis on the original key PNG's alpha
// channel: the ring+dot formed their own small island, fully disconnected
// from the wide arms on either side. Add it to your project at
// assets/images/livinkey_key_ringdot_white.png and register it in
// pubspec.yaml's assets list, alongside the other two images.
const String kLogoRingDotAsset =
    'assets/images/livinkey_key_ringdot_white.png';

/// Original canvas size (px) of the base logo image.
const double _canvasW = 1231;
const double _canvasH = 487;

/// Native size (px) of the CROPPED key asset (see kLogoKeyAsset above).
/// Used to size the key on-screen with its correct aspect ratio, scaled by
/// the same factor as the base logo so it matches the original artwork's
/// proportions exactly.
const double _keyNativeW = 178;
const double _keyNativeH = 296;

/// Where the tight ring+dot crop sits inside the full key asset's own
/// 178x296 coordinate space (measured directly from the pixel data), and
/// how big that crop is.
const double _ringDotCropLeft = 64;
const double _ringDotCropTop = 10;
const double _ringDotNativeW = 53;
const double _ringDotNativeH = 54;

/// The key's fixed, natural resting position on the canvas (next to the
/// "e" in "Livinke"). The key NEVER moves from here anymore — only the
/// ring+dot piece animates, as requested.
const Offset _keyRestPosition = Offset(1125, 322);

/// The center-point where the bouncing ring+dot piece needs to land so it
/// sits exactly in the gap left behind in the static key artwork (the key
/// asset no longer draws its own ring+dot — this animation is now the
/// only place they're drawn). Computed from the key's own top-left corner
/// plus the ring+dot's known offset inside the original key asset — no
/// guessing.
final Offset _topRestCenter = Offset(
  _keyRestPosition.dx - _keyNativeW / 2 + _ringDotCropLeft + _ringDotNativeW / 2,
  _keyRestPosition.dy - _keyNativeH / 2 + _ringDotCropTop + _ringDotNativeH / 2,
);

/// ------------------------------------------------------------------
/// Bounce path waypoints for the small dot.
///
/// These are the ACTUAL measured centers of each letter, taken directly
/// from livinkey_base_white.png's pixel data (found via alpha-channel
/// connected-component analysis, since the letters are white-on-transparent
/// and invisible to the eye against a white background):
///   L -> (137, 215)   v -> (366, 244)   n -> (611, 242)
///   k -> (784, 210)   e -> (950, 244)
/// Both "i"s are skipped as stops — the dot hops right past each i's stem
/// without landing on it. The final waypoint is computed above so the dot
/// lands exactly on the real dot already drawn on the key artwork.
/// ------------------------------------------------------------------
final List<Offset> _dotPath = [
  const Offset(133, 15), // 0: Start - directly above the roof apex
  const Offset(137, 215), // 1: 'L'
  const Offset(366, 244), // 2: 'v'   (hops right over the first 'i')
  const Offset(611, 242), // 3: 'n'   (hops right over the second 'i')
  const Offset(784, 210), // 4: 'k'
  const Offset(950, 244), // 5: 'e'
  _topRestCenter, // 6: End - lands exactly on the key's own ring + dot
];

/// Extra upward arc height added to each hop (in canvas px), one entry
/// per segment (_dotPath.length - 1 segments). Decreasing values give the
/// classic "losing energy" bounce feel as the dot approaches its home.
const List<double> _hopHeights = [36, 70, 55, 44, 32, 20];

const double kLogoAspectRatio = _canvasW / _canvasH;

/// Full "Livinkey — A Complete Home" logo. The key artwork (arms, shaft,
/// teeth) is completely static, fixed at its natural resting spot — it no
/// longer includes the ring or dot at all. Only the ring + dot piece
/// (kLogoRingDotAsset) animates: it drops in from above the roof and
/// bounces across the letters of "Livinke" until it lands exactly in the
/// gap left for it at the top of the key, where it stays — completing the
/// logo. Use this ONLY on the Splash screen.
class LivinkeyLogo extends StatelessWidget {
  final Animation<double> keyAnimation;
  final double width;
  final bool showDebugPoints;

  const LivinkeyLogo({
    super.key,
    required this.keyAnimation,
    this.width = 300,
    this.showDebugPoints = false,
  });

  double _lerp(double a, double b, double t) => a + (b - a) * t;

  double _easeInOutCubic(double t) {
    return t < 0.5 ? 4 * t * t * t : 1 - math.pow(-2 * t + 2, 3) / 2;
  }

  /// Returns (position, squashScaleX, squashScaleY, opacity) for the
  /// bouncing dot at the given overall animation progress.
  _DotState _getDotState(double progress) {
    if (progress <= 0) {
      return _DotState(_dotPath.first, 1.0, 1.0, 1.0);
    }
    if (progress >= 1) {
      return _DotState(_dotPath.last, 1.0, 1.0, 1.0);
    }

    // Weight each segment's share of the timeline by its straight-line
    // distance, same approach as measuring the overall path length.
    double totalLength = 0;
    final List<double> segmentLengths = [];
    for (int i = 0; i < _dotPath.length - 1; i++) {
      final dx = _dotPath[i + 1].dx - _dotPath[i].dx;
      final dy = _dotPath[i + 1].dy - _dotPath[i].dy;
      final length = math.sqrt(dx * dx + dy * dy);
      segmentLengths.add(length);
      totalLength += length;
    }

    final double targetDistance = progress * totalLength;
    double accumulated = 0;

    for (int i = 0; i < segmentLengths.length; i++) {
      final segLen = segmentLengths[i];
      if (targetDistance <= accumulated + segLen || i == segmentLengths.length - 1) {
        final double t = segLen == 0
            ? 1.0
            : ((targetDistance - accumulated) / segLen).clamp(0.0, 1.0);

        final Offset start = _dotPath[i];
        final Offset end = _dotPath[i + 1];

        // Horizontal motion eases in/out per hop.
        final double easedT = _easeInOutCubic(t);
        final double x = _lerp(start.dx, end.dx, easedT);

        // Vertical motion: straight-line lerp minus a parabolic arc lift,
        // using raw t so the arc peaks cleanly at the midpoint of the hop.
        final double baseY = _lerp(start.dy, end.dy, t);
        final double arc = _hopHeights[i] * math.sin(math.pi * t);
        final double y = baseY - arc;

        // Cartoon squash-and-stretch: flattened at contact (t=0/1),
        // stretched tall mid-flight (t=0.5).
        final double peak = math.sin(math.pi * t);
        final double scaleY = 0.75 + 0.45 * peak;
        final double scaleX = 1.25 - 0.35 * peak;

        // No fade-out: the static key artwork no longer includes the
        // ring+dot, so this piece has to stay fully visible once it
        // lands — it's the only place that part of the key is drawn.
        return _DotState(Offset(x, y), scaleX, scaleY, 1.0);
      }
      accumulated += segLen;
    }

    return _DotState(_dotPath.last, 1.0, 1.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final double scale = width / _canvasW;
    final double keyW = _keyNativeW * scale;
    final double keyH = _keyNativeH * scale;
    final double keyScreenX = _keyRestPosition.dx * scale;
    final double keyScreenY = _keyRestPosition.dy * scale;
    final double topW = _ringDotNativeW * scale;
    final double topH = _ringDotNativeH * scale;

    return SizedBox(
      width: width,
      height: width / kLogoAspectRatio,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Base logo image
          Image.asset(
            kLogoBaseAsset,
            fit: BoxFit.fill,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[200],
                child: const Center(
                  child: Text('Logo base not found'),
                ),
              );
            },
          ),

          // Static key, always at its natural resting position — no
          // sliding, no rotating. It never moves.
          Positioned(
            left: keyScreenX - (keyW / 2),
            top: keyScreenY - (keyH / 2),
            child: SizedBox(
              width: keyW,
              height: keyH,
              child: Image.asset(
                kLogoKeyAsset,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.red.withOpacity(0.3),
                    child: const Icon(Icons.vpn_key,
                        color: Colors.red, size: 50),
                  );
                },
              ),
            ),
          ),

          // Bouncing ring+dot piece: drops from above the roof, hops
          // across the letters, lands in the gap left for it at the top
          // of the key, and stays there — it's the only place this part
          // of the key is drawn, since the static key asset no longer
          // includes it.
          AnimatedBuilder(
            animation: keyAnimation,
            builder: (context, child) {
              final double progress = keyAnimation.value;
              final _DotState state = _getDotState(progress);

              final double screenX = state.position.dx * scale;
              final double screenY = state.position.dy * scale;

              if (state.opacity <= 0) return const SizedBox.shrink();

              return Positioned(
                left: screenX - (topW / 2),
                top: screenY - (topH / 2),
                child: Opacity(
                  opacity: state.opacity,
                  child: Transform.scale(
                    scaleX: state.scaleX,
                    scaleY: state.scaleY,
                    child: SizedBox(
                      width: topW,
                      height: topH,
                      child: Image.asset(
                        kLogoRingDotAsset,
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.red.withOpacity(0.3),
                            child: const Icon(Icons.circle_outlined,
                                color: Colors.red, size: 30),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Debug overlay to show waypoints
          if (showDebugPoints)
            CustomPaint(
              painter: _DebugPathPainter(scale: scale),
              size: Size(width, width / kLogoAspectRatio),
            ),
        ],
      ),
    );
  }
}

class _DotState {
  final Offset position;
  final double scaleX;
  final double scaleY;
  final double opacity;

  _DotState(this.position, this.scaleX, this.scaleY, this.opacity);
}

/// Static-position logo used on the Get Started screen (and anywhere else
/// that only wants a rotation, not the bounce). The key sits fixed at its
/// natural resting spot next to the "e" and rotates in place from
/// straight (0) to fully upside down (pi) as `keyAnimation` goes from 0 -> 1.
class LivinkeyLogoKeyFlip extends StatelessWidget {
  final Animation<double> keyAnimation; // 0 = straight, 1 = upside down
  final double width;

  const LivinkeyLogoKeyFlip({
    super.key,
    required this.keyAnimation,
    this.width = 300,
  });

  @override
  Widget build(BuildContext context) {
    final double scale = width / _canvasW;
    final Offset restPosition = _keyRestPosition;

    final double keyW = _keyNativeW * scale;
    final double keyH = _keyNativeH * scale;
    final double screenX = restPosition.dx * scale;
    final double screenY = restPosition.dy * scale;

    return SizedBox(
      width: width,
      height: width / kLogoAspectRatio,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            kLogoBaseAsset,
            fit: BoxFit.fill,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[200],
                child: const Center(
                  child: Text('Logo base not found'),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: keyAnimation,
            builder: (context, child) {
              final double rotation = keyAnimation.value * math.pi;

              return Positioned(
                left: screenX - (keyW / 2),
                top: screenY - (keyH / 2),
                child: Transform.rotate(
                  angle: rotation,
                  child: SizedBox(
                    width: keyW,
                    height: keyH,
                    child: Image.asset(
                      kLogoKeyAsset,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.red.withOpacity(0.3),
                          child: const Icon(Icons.vpn_key,
                              color: Colors.red, size: 50),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Debug painter to visualize the dot's bounce path (Splash screen only)
class _DebugPathPainter extends CustomPainter {
  final double scale;

  _DebugPathPainter({required this.scale});

  @override
  void paint(Canvas canvas, Size size) {
    final pathPaint = Paint()
      ..color = Colors.red.withOpacity(0.8)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    for (int i = 0; i < _dotPath.length; i++) {
      final double x = _dotPath[i].dx * scale;
      final double y = _dotPath[i].dy * scale;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, pathPaint);

    final letterHints = ['Start', 'L', 'v', 'n', 'k', 'e', 'Dot rest'];
    for (int i = 0; i < _dotPath.length; i++) {
      final double x = _dotPath[i].dx * scale;
      final double y = _dotPath[i].dy * scale;

      final Paint pointPaint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x, y), 10, pointPaint);

      canvas.drawCircle(
          Offset(x, y),
          10,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2);

      final textSpan = TextSpan(
        text: '$i',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x + 12, y - 8));

      if (i < letterHints.length) {
        final hintSpan = TextSpan(
          text: letterHints[i],
          style: const TextStyle(
            color: Colors.yellow,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        );
        final hintPainter = TextPainter(
          text: hintSpan,
          textDirection: TextDirection.ltr,
        );
        hintPainter.layout();
        hintPainter.paint(canvas, Offset(x - 20, y + 16));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Main app widget with animation control (Debug only)
class LivinkeyLogoExample extends StatefulWidget {
  const LivinkeyLogoExample({super.key});

  @override
  State<LivinkeyLogoExample> createState() => _LivinkeyLogoExampleState();
}

class _LivinkeyLogoExampleState extends State<LivinkeyLogoExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isAnimating = false;
  bool _showDebug = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3200),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() => _isAnimating = false);
        }
      });

    // Linear drive here: the bounce shaping (arcs, ease per hop, squash)
    // is already handled inside LivinkeyLogo, so we don't want a second
    // easing curve fighting it.
    _animation = _controller;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleAnimation() {
    if (_isAnimating) {
      _controller.stop();
      setState(() => _isAnimating = false);
    } else {
      if (_controller.isCompleted) {
        _controller.reset();
      }
      setState(() => _isAnimating = true);
      _controller.forward();
    }
  }

  void _resetAnimation() {
    _controller.stop();
    _controller.reset();
    setState(() => _isAnimating = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Livinkey Logo Debug'),
        backgroundColor: kLivinkeyGreen,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_showDebug ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(() => _showDebug = !_showDebug),
            tooltip: 'Toggle Debug Points',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(16),
              child: LivinkeyLogo(
                keyAnimation: _animation,
                width: MediaQuery.of(context).size.width * 0.9,
                showDebugPoints: _showDebug,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    'Progress: ${(_animation.value * 100).round()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Status: ${_isAnimating ? "▶️ Playing" : "⏸️ Paused"}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _toggleAnimation,
                  icon: Icon(_isAnimating ? Icons.pause : Icons.play_arrow),
                  label: Text(_isAnimating ? 'Pause' : 'Play'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kLivinkeyGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _resetAnimation,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: LinearProgressIndicator(
                value: _animation.value,
                backgroundColor: Colors.grey[300],
                valueColor:
                    const AlwaysStoppedAnimation<Color>(kLivinkeyGreen),
                minHeight: 10,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _isAnimating
                  ? '🔄 Animating...'
                  : (_controller.isCompleted ? '✅ Complete!' : '⏸️ Ready'),
              style: TextStyle(
                fontSize: 14,
                color: _controller.isCompleted ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}