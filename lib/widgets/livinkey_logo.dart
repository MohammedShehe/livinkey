import 'dart:math' as math;
import 'package:flutter/material.dart';

/// ------------------------------------------------------------------
/// BRAND COLORS — tweak kLivinkeyGreen if you have the exact hex from
/// your design file (this is a close match to the logo you shared).
/// ------------------------------------------------------------------
const Color kLivinkeyGreen = Color(0xFF6FBF3C);
const Color kLivinkeyBlack = Color(0xFF000000);
const Color kLivinkeyWhite = Color(0xFFFFFFFF);

/// The full "Livinkey — A Complete Home" logo, with the key (the "y")
/// driven by an external animation value (0 = final "facing down"
/// position, 1 = starting "straight up" position).
class LivinkeyLogo extends StatelessWidget {
  final Animation<double> keyAnimation;
  final double fontSize;

  const LivinkeyLogo({
    super.key,
    required this.keyAnimation,
    this.fontSize = 46,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w900,
      color: kLivinkeyWhite,
      height: 1.0,
      letterSpacing: -1,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // "L" with the roof outline sitting above it
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topLeft,
              children: [
                Positioned(
                  top: -fontSize * 0.46,
                  left: fontSize * 0.02,
                  child: CustomPaint(
                    size: Size(fontSize * 0.62, fontSize * 0.46),
                    painter: RoofPainter(color: kLivinkeyGreen),
                  ),
                ),
                Text('L', style: titleStyle),
              ],
            ),
            Text('ivinke', style: titleStyle),
            // Animated key replacing the "y"
            AnimatedBuilder(
              animation: keyAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: keyAnimation.value * math.pi,
                  alignment: Alignment.center,
                  child: child,
                );
              },
              child: SizedBox(
                width: fontSize * 0.62,
                height: fontSize * 1.05,
                child: CustomPaint(
                  painter: KeyPainter(color: kLivinkeyGreen),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: fontSize * 0.16),
        Text(
          'A COMPLETE HOME',
          style: TextStyle(
            fontSize: fontSize * 0.245,
            fontWeight: FontWeight.w700,
            color: kLivinkeyGreen,
            letterSpacing: fontSize * 0.09,
          ),
        ),
      ],
    );
  }
}

/// Small roof / house outline (the little green peak above the "L")
class RoofPainter extends CustomPainter {
  final Color color;
  RoofPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.11
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height * 0.62);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant RoofPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// The key shape used as the "y" in "Livinkey":
/// a round bow (with keyhole dot) + shaft + tooth.
class KeyPainter extends CustomPainter {
  final Color color;
  KeyPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.16
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final bowRadius = size.width * 0.42;
    final bowCenter = Offset(size.width / 2, bowRadius + size.width * 0.08);

    // Bow (the round top of the key)
    canvas.drawCircle(bowCenter, bowRadius, strokePaint);

    // Keyhole dot in the middle of the bow
    canvas.drawCircle(bowCenter, size.width * 0.09, fillPaint);

    // Shaft
    final shaftTop = bowCenter.dy + bowRadius - size.width * 0.05;
    final shaftWidth = size.width * 0.22;
    final shaftRect = Rect.fromLTWH(
      (size.width - shaftWidth) / 2,
      shaftTop,
      shaftWidth,
      size.height - shaftTop - size.width * 0.05,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(shaftRect, Radius.circular(shaftWidth / 2)),
      fillPaint,
    );

    // Tooth sticking out near the bottom of the shaft
    final toothWidth = size.width * 0.34;
    final toothHeight = size.width * 0.16;
    final toothRect = Rect.fromLTWH(
      shaftRect.center.dx,
      size.height - toothHeight * 2.1,
      toothWidth,
      toothHeight,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(toothRect, Radius.circular(toothHeight / 2)),
      fillPaint,
    );
  }

  @override
  bool shouldRepaint(covariant KeyPainter oldDelegate) =>
      oldDelegate.color != color;
}