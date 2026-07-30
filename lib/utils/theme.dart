import 'package:flutter/material.dart';
import 'constants.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      scaffoldBackgroundColor: kLivinkeyBlack,
      colorScheme: ColorScheme.fromSeed(
        seedColor: kLivinkeyGreen,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: kLivinkeyBlack,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: kLivinkeyBlack,
        selectedItemColor: kLivinkeyGreen,
        unselectedItemColor: Colors.white38,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: kLivinkeyBlack,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: kLivinkeyBlack,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  static BoxDecoration gradientCard(Color color) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          color.withOpacity(0.12),
          color.withOpacity(0.03),
        ],
      ),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: color.withOpacity(0.15),
        width: 1,
      ),
    );
  }

  static BoxDecoration gradientContainer(Color color) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          color.withOpacity(0.08),
          Colors.transparent,
        ],
      ),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: color.withOpacity(0.1),
        width: 1,
      ),
    );
  }

  static BoxDecoration inputDecoration() {
    return BoxDecoration(
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
        color: kLivinkeyWhite.withOpacity(0.1),
        width: 1,
      ),
    );
  }
}