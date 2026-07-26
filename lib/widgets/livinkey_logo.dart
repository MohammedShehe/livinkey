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
/// Because they share the same canvas, we can stack them and rotate
/// just the key layer around its true center.
const String kLogoBaseAsset = 'assets/images/livinkey_base_white.png';
const String kLogoKeyAsset = 'assets/images/livinkey_key_green.png';

/// Original cropped canvas size (px) — used only to derive the aspect
/// ratio and the key's rotation pivot. Don't need to touch these unless
/// you re-export the assets with different crop padding.
const double _canvasW = 1231;
const double _canvasH = 487;
const double _keyCenterX = 1125.0;
const double _keyCenterY = 322.0;

/// The key's center expressed as an Alignment (-1..1 space) so
/// Transform.rotate pivots around the real bow/shaft, not a guess.
const Alignment kKeyPivot = Alignment(
  (_keyCenterX / _canvasW) * 2 - 1, // ~0.828
  (_keyCenterY / _canvasH) * 2 - 1, // ~0.322
);

const double kLogoAspectRatio = _canvasW / _canvasH; // ~2.53

/// Full "Livinkey — A Complete Home" logo, built from the real artwork,
/// with the key driven by an external animation value:
///   1.0 = key "straight" (starting position)
///   0.0 = key "facing down" (final position, matches your logo exactly)
class LivinkeyLogo extends StatelessWidget {
  final Animation<double> keyAnimation;
  final double width;

  const LivinkeyLogo({
    super.key,
    required this.keyAnimation,
    this.width = 300,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: width / kLogoAspectRatio,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(kLogoBaseAsset, fit: BoxFit.fill),
          AnimatedBuilder(
            animation: keyAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: keyAnimation.value * math.pi,
                alignment: kKeyPivot,
                child: child,
              );
            },
            child: Image.asset(kLogoKeyAsset, fit: BoxFit.fill),
          ),
        ],
      ),
    );
  }
}