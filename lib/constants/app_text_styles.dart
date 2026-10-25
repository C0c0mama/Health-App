// lib/constants/app_text_styles.dart
// Typography system for Barangay Health App

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // --- Display ---
  static TextStyle get displayLarge => GoogleFonts.plusJakartaSans(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle get displayMedium => GoogleFonts.plusJakartaSans(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );

  // --- Headings ---
  static TextStyle get h1 => GoogleFonts.plusJakartaSans(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle get h2 => GoogleFonts.plusJakartaSans(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get h3 => GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // --- Body ---
  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );

  // --- Labels ---
  static TextStyle get labelLarge => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get labelMedium => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static TextStyle get labelSmall => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
    letterSpacing: 0.3,
  );

  // --- Specialized ---
  static TextStyle get buttonText => GoogleFonts.plusJakartaSans(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    letterSpacing: 0.2,
  );

  static TextStyle get caption => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );
}

// ──────────────────────────────────────────────────────────────────────────────
// lib/constants/app_strings.dart
// ──────────────────────────────────────────────────────────────────────────────
class AppStrings {
  AppStrings._();

  static const String appName = 'BrgyHealth';
  static const String appFullName = 'Barangay Pampang Health System';
  static const String tagline = 'Your Health, Our Priority';

  // Auth
  static const String login = 'Log In';
  static const String register = 'Register';
  static const String logout = 'Log Out';
  static const String email = 'Email Address';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String fullName = 'Full Name';
  static const String noAccount = "Don't have an account? ";
  static const String hasAccount = 'Already have an account? ';
  static const String signUp = 'Sign Up';
  static const String signIn = 'Sign In';

  // Navigation
  static const String home = 'Home';
  static const String records = 'Records';
  static const String appointments = 'Schedule';
  static const String notifications = 'Alerts';
  static const String profile = 'Profile';

  // Home
  static const String goodMorning = 'Good Morning';
  static const String goodAfternoon = 'Good Afternoon';
  static const String goodEvening = 'Good Evening';
  static const String upcomingAppointments = 'Upcoming Appointments';
  static const String recentNotifications = 'Recent Alerts';
  static const String healthAnnouncements = 'Health Announcements';
  static const String quickAccess = 'Quick Access';
  static const String seeAll = 'See All';

  // Records
  static const String healthRecords = 'Health Records';
  static const String maternalHealth = 'Maternal Health';
  static const String vaccinationRecords = 'Vaccination Records';
  static const String prenatalHistory = 'Prenatal History';
  static const String patientProfile = 'Patient Profile';

  // Appointments
  static const String myAppointments = 'My Appointments';
  static const String upcoming = 'Upcoming';
  static const String completed = 'Completed';
  static const String cancelled = 'Cancelled';

  // Notifications
  static const String myNotifications = 'Notifications';
  static const String markAllRead = 'Mark all as read';
  static const String unread = 'Unread';
  static const String all = 'All';
}
