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
/// These were RE-MEASURED directly against livinkey_base_white.png's
/// alpha channel (the actual 1231x487 canvas) using connected-component
/// labeling to isolate each glyph, then a column-by-column scan for the
/// topmost opaque pixel across each glyph's width. That's a different
/// (and more precise) thing than each glyph's overall bounding-box
/// center, which is what was used before — and the difference matters
/// for three of these five letters:
///
///   • 'v' is TWO strokes. The column scan shows a flat top from
///     x=291-339 (the FIRST/left leg's own flat top), then a dip down
///     to the vertex around x=366, then a second flat top from
///     x=394-440 (the SECOND/last leg's own flat top). You asked for
///     the LAST leg specifically, so we land on the x=394-440 plateau,
///     centered at x=417 — not the glyph's overall midpoint (~365),
///     which falls in the dip between the two legs, and not the first
///     leg either.
///   • 'n' has no flat plateau on top — it's a smooth arch connecting
///     both legs. Its topmost point (the "bow") is a rounded peak
///     measured at x=632, y=175. That's noticeably right of the
///     glyph's raw bounding-box center (~611) because the right leg
///     carries slightly further before the arch crests.
///   • 'k' has arms flaring out to the right, which drags its bounding-
///     box center well right of the ascender itself. The column scan
///     isolates just the ascender's own flat top, x=708-753, centered
///     at x=730 — not the average of the ascender + arms (~784, the
///     old value, which was actually landing out past the ascender and
///     into empty space above the arms).
///   • 'L' and 'e' didn't have this ambiguity (a single flat-topped
///     stroke for L, a single rounded crest for e), so their measured
///     flat-top centers are used directly: L at x=105, e at x=951.
///
/// Measured topmost-pixel y for each, in canvas px (before the landing
/// clearance below is subtracted):
///   L: y=122   v (last leg): y=180   n (bow): y=175   k: y=111   e: y=176
///
/// Both "i"s are skipped as stops — the dot hops right past each i's stem
/// without landing on it. The final waypoint is computed above so the dot
/// lands exactly on the real dot already drawn on the key artwork.
/// ------------------------------------------------------------------

/// Lifts every letter-landing waypoint up off its glyph's measured top
/// pixel by roughly the bouncing piece's own squashed radius. Without
/// this, the ring/dot graphic's CENTER (not its edge) would sit exactly
/// on the measured top pixel, and the lower half of the graphic would
/// visibly bury itself into the letter instead of appearing to rest on
/// top of it. This is one fixed visual constant applied identically to
/// every letter — it is not a per-letter position guess. It is NOT
/// applied to the final key-landing waypoint (_topRestCenter), since
/// that point is already computed to align pixel-for-pixel with the gap
/// left in the static key artwork, and adding clearance there would
/// throw that alignment off.
const double _dotRestClearance = 21; // ≈ (_ringDotNativeH / 2) * squash-at-rest

final List<Offset> _dotPath = [
  const Offset(134, 15), // 0: Start - directly above the measured roof apex (x=134)
  const Offset(105, 122 - _dotRestClearance), // 1: 'L' — top of its vertical stroke
  const Offset(417, 180 - _dotRestClearance), // 2: 'v' — top of its LAST (right) leg
  const Offset(632, 175 - _dotRestClearance), // 3: 'n' — top of its bow/arch
  const Offset(730, 111 - _dotRestClearance), // 4: 'k' — top of its ascender
  const Offset(951, 176 - _dotRestClearance), // 5: 'e' — top of its crest
  _topRestCenter, // 6: End - lands exactly on the key's own ring + dot
];

/// Extra upward arc height added to each hop (in canvas px), one entry
/// per segment (_dotPath.length - 1 segments). Slightly taller and more
/// gradually decreasing than before, so each hop reads as a full, lazy
/// arc rather than a quick flick — reinforces the "losing energy" bounce
/// feel as the dot approaches its home.
const List<double> _hopHeights = [52, 86, 68, 56, 40, 24];

const double kLogoAspectRatio = _canvasW / _canvasH;

/// Full "Livinkey — A Complete Home" logo. The key artwork (arms, shaft,
/// teeth) is completely static, fixed at its natural resting spot — it no
/// longer includes the ring or dot at all. Only the ring + dot piece
/// (kLogoRingDotAsset) animates: it drops in from above the roof and
/// bounces across the TOP EDGES of the letters of "Livinke" until it
/// lands exactly in the gap left for it at the top of the key, where it
/// stays — completing the logo. Use this ONLY on the Splash screen.
///
/// Drive `keyAnimation` with a controller of ~9-10s (see SplashScreen)
/// for a slow, smooth bounce rather than a quick one.
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

  /// Sine-based ease-in-out. Compared to the cubic ease previously used,
  /// this has a gentler, more rounded shoulder at both ends of each hop,
  /// which is what reads as "smooth/slow" rather than "snappy" motion.
  /// Both the horizontal motion and the vertical arc/squash now share
  /// this same eased value, so they stay perfectly in sync — that
  /// synchronization is a big part of what makes a bounce look smooth.
  double _easeInOutSine(double t) {
    return -(math.cos(math.pi * t) - 1) / 2;
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

        // Horizontal motion eases in/out per hop using the smoother sine
        // curve.
        final double easedT = _easeInOutSine(t);
        final double x = _lerp(start.dx, end.dx, easedT);

        // Vertical motion: straight-line lerp minus a parabolic arc lift.
        // The arc now uses the SAME easedT as the horizontal motion (not
        // raw t) so the peak of the arc lines up exactly with the
        // midpoint of horizontal travel — this removes the subtle
        // "wobble" you get when x and y are paced differently.
        final double baseY = _lerp(start.dy, end.dy, easedT);
        final double arc = _hopHeights[i] * math.sin(math.pi * easedT);
        final double y = baseY - arc;

        // Cartoon squash-and-stretch: flattened at contact (t=0/1),
        // stretched tall mid-flight (peak of the hop). Also driven off
        // easedT so it settles in step with the rest of the motion
        // instead of snapping.
        final double peak = math.sin(math.pi * easedT);
        final double scaleY = 0.78 + 0.4 * peak;
        final double scaleX = 1.22 - 0.32 * peak;

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
          // across the top edges of the letters, lands in the gap left
          // for it at the top of the key, and stays there — it's the
          // only place this part of the key is drawn, since the static
          // key asset no longer includes it.
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

/// Static-position logo used on the Get Started screen. The key sits
/// fixed at its natural resting spot, always upright — it never rotates
/// and never moves. Only the ring+dot piece animates, and it only bounces
/// straight up and down in place, directly above the key's bow (its
/// natural resting spot on the artwork). It never travels sideways and
/// never leaves that spot.
///
/// Drive `bounceAnimation` with a repeating (reverse: true) controller so
/// the value oscillates 0 -> 1 -> 0 -> 1 ... for a continuous idle bounce.
class LivinkeyLogoKeyBounce extends StatelessWidget {
  final Animation<double> bounceAnimation; // 0 = resting, 1 = peak of bounce
  final double width;

  /// How far (in canvas px, pre-scale) the ring+dot lifts off its resting
  /// spot at the peak of the bounce.
  final double bounceHeight;

  const LivinkeyLogoKeyBounce({
    super.key,
    required this.bounceAnimation,
    this.width = 300,
    this.bounceHeight = 18,
  });

  @override
  Widget build(BuildContext context) {
    final double scale = width / _canvasW;
    final Offset restPosition = _keyRestPosition;

    final double keyW = _keyNativeW * scale;
    final double keyH = _keyNativeH * scale;
    final double keyScreenX = restPosition.dx * scale;
    final double keyScreenY = restPosition.dy * scale;

    final double topW = _ringDotNativeW * scale;
    final double topH = _ringDotNativeH * scale;
    final double topScreenX = _topRestCenter.dx * scale;
    final double topScreenY = _topRestCenter.dy * scale;

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

          // Static key, always upright at its natural resting position —
          // no rotation, no sliding. It never moves.
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

          // Bouncing ring+dot piece: fixed horizontally at its natural
          // resting spot directly above the key's bow, only ever moving
          // up and down in place.
          AnimatedBuilder(
            animation: bounceAnimation,
            builder: (context, child) {
              final double lift = bounceAnimation.value * bounceHeight * scale;

              // Subtle squash-and-stretch to sell the bounce: stretches
              // tall at the peak, settles back to normal at rest.
              final double peak = bounceAnimation.value;
              final double scaleY = 1.0 + 0.12 * peak;
              final double scaleX = 1.0 - 0.08 * peak;

              return Positioned(
                left: topScreenX - (topW / 2),
                top: topScreenY - (topH / 2) - lift,
                child: Transform.scale(
                  scaleX: scaleX,
                  scaleY: scaleY,
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
      // Slowed down to match the smoother splash-screen timing.
      duration: const Duration(milliseconds: 4200),
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