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
const String kLogoKeyAsset = 'assets/images/livinkey_key_white.png';

/// Original canvas size (px) of the base logo image.
const double _canvasW = 1231;
const double _canvasH = 487;

/// Native size (px) of the CROPPED key asset (see kLogoKeyAsset above).
/// Used to size the key on-screen with its correct aspect ratio, scaled by
/// the same factor as the base logo so it matches the original artwork's
/// proportions exactly.
const double _keyNativeW = 178;
const double _keyNativeH = 296;

/// ------------------------------------------------------------------
/// Key path waypoints through "Livinke"
///
/// These are the ACTUAL measured centers of each letter, taken directly
/// from livinkey_base_white.png's pixel data (found via alpha-channel
/// connected-component analysis, since the letters are white-on-transparent
/// and invisible to the eye against a white background):
///   L -> (137, 215)   v -> (366, 244)   n -> (611, 242)
///   k -> (784, 210)   e -> (950, 244)
/// Both "i"s are skipped as stops — the straight L->v and v->n segments
/// naturally glide right past each i's stem without pausing on it.
/// The final waypoint (1125, 322) is the key artwork's own natural resting
/// position in the original file, so the animation ends exactly where the
/// static design intended.
/// ------------------------------------------------------------------
const List<Offset> _keyPath = [
  Offset(133, 15),    // 0: Start - directly above the roof apex
  Offset(137, 215),   // 1: 'L'
  Offset(366, 244),   // 2: 'v'   (passes right by the first 'i' en route)
  Offset(611, 242),   // 3: 'n'   (passes right by the second 'i' en route)
  Offset(784, 210),   // 4: 'k'
  Offset(950, 244),   // 5: 'e'
  Offset(1125, 322),  // 6: End - key's natural resting position
];

/// Rotation values at each waypoint (radians). The key now stays upright
/// for the entire slide and finishes STRAIGHT (like a 'Y') instead of
/// flipping upside down — the flip itself now lives in the Get Started
/// screen's rotation-only animation instead.
const List<double> _keyRotations = [
  0.0, // 0: start, upright
  0.0, // 1: L
  0.0, // 2: v
  0.0, // 3: n
  0.0, // 4: k
  0.0, // 5: e
  0.0, // 6: end - straight
];

const double kLogoAspectRatio = _canvasW / _canvasH;

/// Full "Livinkey — A Complete Home" logo with key sliding through letters.
/// Use this ONLY on the Splash screen — it drives both the key's position
/// and (now flat) rotation along the letter path.
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

  Offset _getKeyPosition(double progress) {
    if (progress <= 0) return _keyPath.first;
    if (progress >= 1) return _keyPath.last;

    double totalLength = 0;
    List<double> segmentLengths = [];

    for (int i = 0; i < _keyPath.length - 1; i++) {
      double dx = _keyPath[i + 1].dx - _keyPath[i].dx;
      double dy = _keyPath[i + 1].dy - _keyPath[i].dy;
      double length = math.sqrt(dx * dx + dy * dy);
      segmentLengths.add(length);
      totalLength += length;
    }

    double targetDistance = progress * totalLength;
    double accumulatedDistance = 0;

    for (int i = 0; i < segmentLengths.length; i++) {
      if (targetDistance <= accumulatedDistance + segmentLengths[i]) {
        double localProgress =
            (targetDistance - accumulatedDistance) / segmentLengths[i];
        double easedProgress = _easeInOutCubic(localProgress);

        return Offset(
          _lerp(_keyPath[i].dx, _keyPath[i + 1].dx, easedProgress),
          _lerp(_keyPath[i].dy, _keyPath[i + 1].dy, easedProgress),
        );
      }
      accumulatedDistance += segmentLengths[i];
    }

    return _keyPath.last;
  }

  double _getKeyRotation(double progress) {
    if (progress <= 0) return _keyRotations.first;
    if (progress >= 1) return _keyRotations.last;

    double totalLength = 0;
    List<double> segmentLengths = [];

    for (int i = 0; i < _keyPath.length - 1; i++) {
      double dx = _keyPath[i + 1].dx - _keyPath[i].dx;
      double dy = _keyPath[i + 1].dy - _keyPath[i].dy;
      double length = math.sqrt(dx * dx + dy * dy);
      segmentLengths.add(length);
      totalLength += length;
    }

    double targetDistance = progress * totalLength;
    double accumulatedDistance = 0;

    for (int i = 0; i < segmentLengths.length; i++) {
      if (targetDistance <= accumulatedDistance + segmentLengths[i]) {
        double localProgress =
            (targetDistance - accumulatedDistance) / segmentLengths[i];
        double easedProgress = _easeInOutCubic(localProgress);

        return _lerp(
          _keyRotations[i],
          _keyRotations[i + 1],
          easedProgress,
        );
      }
      accumulatedDistance += segmentLengths[i];
    }

    return _keyRotations.last;
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;

  double _easeInOutCubic(double t) {
    return t < 0.5 ? 4 * t * t * t : 1 - math.pow(-2 * t + 2, 3) / 2;
  }

  @override
  Widget build(BuildContext context) {
    double scale = width / _canvasW;

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

          // Animated key (slides, stays upright, ends straight)
          AnimatedBuilder(
            animation: keyAnimation,
            builder: (context, child) {
              double progress = keyAnimation.value;
              Offset position = _getKeyPosition(progress);
              double rotation = _getKeyRotation(progress);

              double keyW = _keyNativeW * scale;
              double keyH = _keyNativeH * scale;
              double screenX = position.dx * scale;
              double screenY = position.dy * scale;

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

/// Static-position logo used on the Get Started screen (and anywhere else
/// that only wants a rotation, not the letter-by-letter slide). The key
/// sits fixed at its natural resting spot next to the "e" and rotates in
/// place from straight (0) to fully upside down (pi) as `keyAnimation`
/// goes from 0 -> 1.
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
    final Offset restPosition = _keyPath.last; // (1125, 322)

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

/// Debug painter to visualize the key path (Splash screen only)
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
    for (int i = 0; i < _keyPath.length; i++) {
      double x = _keyPath[i].dx * scale;
      double y = _keyPath[i].dy * scale;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, pathPaint);

    final letterHints = ['Start', 'L', 'v', 'n', 'k', 'e', 'End'];
    for (int i = 0; i < _keyPath.length; i++) {
      double x = _keyPath[i].dx * scale;
      double y = _keyPath[i].dy * scale;

      Paint pointPaint = Paint()
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
      duration: const Duration(milliseconds: 6000),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() => _isAnimating = false);
        }
      });

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutSine,
    );
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