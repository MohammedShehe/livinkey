import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final bool isLoading;
  final bool isOutlined;
  final double height;
  final Color? color;

  const GradientButton({
    super.key,
    this.onPressed,
    required this.label,
    this.icon,
    this.isLoading = false,
    this.isOutlined = false,
    this.height = 56,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? kLivinkeyGreen;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: height,
      decoration: isOutlined
          ? null
          : BoxDecoration(
              gradient: LinearGradient(
                colors: [buttonColor, Color(0xFF4CAF50)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: buttonColor.withOpacity(0.3),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: buttonColor.withOpacity(0.1),
                  blurRadius: 40,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined ? Colors.transparent : Colors.transparent,
          foregroundColor: isOutlined ? Colors.white : Colors.black,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: isOutlined
              ? BorderSide(
                  color: kLivinkeyWhite.withOpacity(0.15),
                  width: 1.5,
                )
              : BorderSide.none,
          elevation: 0,
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isOutlined ? Colors.white : Colors.black,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      color: isOutlined ? Colors.white : Colors.black,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isOutlined ? Colors.white : Colors.black,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}