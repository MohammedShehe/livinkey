import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class DocumentCard extends StatelessWidget {
  final Map<String, String> doc;
  final bool hasPhoto;
  final VoidCallback onTap;

  const DocumentCard({
    super.key,
    required this.doc,
    required this.hasPhoto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              kLivinkeyWhite.withOpacity(0.05),
              kLivinkeyWhite.withOpacity(0.02),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: kLivinkeyWhite.withOpacity(0.08),
            width: 1,
          ),
        ),
        // LayoutBuilder reads the ACTUAL box this card is given (by the
        // GridView's childAspectRatio, the screen width, crossAxisCount,
        // etc.) instead of assuming a fixed size. Everything below is
        // sized off `constraints` so the icon/photo square and its
        // contents always fit the card they're actually drawn in,
        // whatever that turns out to be on a given device.
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Icon/photo square: scales with the card, but is clamped so
            // it never gets so big it crowds out the label on a tall
            // narrow card, and never shrinks below a size where the
            // emoji/icon inside it would look cramped.
            final double shortestSide =
                math.min(constraints.maxWidth, constraints.maxHeight);
            final double boxSize = (shortestSide * 0.55).clamp(48.0, 84.0);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasPhoto)
                    Container(
                      width: boxSize,
                      height: boxSize,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            kLivinkeyGreen.withOpacity(0.2),
                            kLivinkeyGreen.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: kLivinkeyGreen.withOpacity(0.15),
                          width: 1,
                        ),
                      ),
                      // FittedBox guarantees the emoji glyph itself scales
                      // down along with the box on small cards instead of
                      // being clipped/overflowing at a fixed 32px.
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              doc['icon']!,
                              style: const TextStyle(fontSize: 32),
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    Container(
                      width: boxSize,
                      height: boxSize,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.cloud_upload_rounded,
                                color: kLivinkeyGreen.withOpacity(0.5),
                                size: 28,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Upload',
                                style: TextStyle(
                                  color: kLivinkeyGreen.withOpacity(0.4),
                                  fontSize: 9,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  Flexible(
                    child: Text(
                      doc['label']!,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}