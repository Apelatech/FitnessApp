import 'package:flutter/material.dart';

/// ApelaTech Fitness App Color Palette
class AppColors {
  static const Color primary = Color(0xFF1C2526); // Jet Black
  static const Color secondary = Color(0xFF4A90E2); // Sky Blue
  static const Color accent = Color(0xFFFF5733); // Fire Orange
  
  // Semantic colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF43A047);
  static const Color warning = Color(0xFFFB8C00);
  
  // Text colors
  static const Color textPrimary = Color(0xFF1C2526);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textLight = Color(0xFF9E9E9E);
  static const Color textWhite = Colors.white;
  
  // Gradient colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF2A3A3B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, Color(0xFFFF7043)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient blueGradient = LinearGradient(
    colors: [secondary, Color(0xFF64B5F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Dark mode variants
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2D2D2D);
  
  // Chart colors
  static const List<Color> chartColors = [
    accent,
    secondary,
    Color(0xFF66BB6A),
    Color(0xFFFFCA28),
    Color(0xFFAB47BC),
    Color(0xFF26C6DA),
  ];
}
