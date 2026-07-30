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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (hasPhoto)
              Container(
                width: 80,
                height: 80,
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
                child: Center(
                  child: Text(
                    doc['icon']!,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              )
            else
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
            const SizedBox(height: 10),
            Text(
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
          ],
        ),
      ),
    );
  }
}