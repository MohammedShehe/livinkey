import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class SnackbarHelper {
  static void show(
    BuildContext context,
    String message, {
    Color color = kLivinkeyGreen,
    Duration duration = kSnackbarDuration,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: duration,
      ),
    );
  }

  static void showError(BuildContext context, String message) {
    show(context, message, color: Colors.red.shade800);
  }

  static void showSuccess(BuildContext context, String message) {
    show(context, message, color: kLivinkeyGreen);
  }
}