// lib/constants/app_colors.dart
// Central color palette for the Barangay Health App
// Design: Soft blue & green healthcare palette (Material 3)

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // --- Primary Palette ---
  static const Color primary = Color(0xFF1A7FC1); // Deep sky blue
  static const Color primaryLight = Color(0xFF5EB3E8); // Light blue
  static const Color primaryLighter = Color(0xFFE3F4FD); // Very light blue bg

  // --- Secondary / Accent ---
  static const Color secondary = Color(0xFF27A869); // Healthcare green
  static const Color secondaryLight = Color(0xFF6DD5A8); // Light green
  static const Color secondaryLighter = Color(
    0xFFE6F7F1,
  ); // Very light green bg

  // --- Neutral ---
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF5F8FD); // Soft off-white blue tint
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBg = Color(0xFFFFFFFF);

  // --- Text ---
  static const Color textPrimary = Color(0xFF1A2B4A); // Dark navy
  static const Color textSecondary = Color(0xFF5A6D8A); // Muted blue-grey
  static const Color textMuted = Color(0xFF9DAFC5); // Light muted

  // --- Status Colors ---
  static const Color success = Color(0xFF27A869);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // --- Appointment Status ---
  static const Color statusUpcoming = Color(0xFF3B82F6);
  static const Color statusCompleted = Color(0xFF27A869);
  static const Color statusCancelled = Color(0xFFEF4444);
  static const Color statusPending = Color(0xFFF59E0B);

  // --- Gradient ---
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1A7FC1), Color(0xFF27A869)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFF1565C0), Color(0xFF1A7FC1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // --- Divider ---
  static const Color divider = Color(0xFFE8EFF7);
  static const Color border = Color(0xFFD6E4F0);
}
