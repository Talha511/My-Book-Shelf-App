import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette — Olive Green Theme
  static const Color primary = Color(0xFF384325);     // Dark Olive Green
  static const Color primaryDark = Color(0xFF2A3219); // Darker shade
  static const Color secondary = Color(0xFF6A7843);   // Medium Muted Green
  static const Color accent = Color(0xFFA4B195);      // Soft Sage Green

  // Neutral Colors
  static const Color background = Color(0xFFF4F5F0);  // Warm off-white
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1C2110);
  static const Color textSecondary = Color(0xFF5A6345);
  static const Color textLigth = Color(0xFFA4B195);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFF9A825);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );

  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.white70, Colors.white30],
  );
}
