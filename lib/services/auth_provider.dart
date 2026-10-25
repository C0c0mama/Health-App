import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/dummy_data.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isLoading = false;
  bool _isLoggingOut = false;
  UserModel? _currentUser;
  String? _errorMessage;

  // ── Getters ──────────────────────────────────────────────────────────────
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  bool get isLoggingOut => _isLoggingOut;
  UserModel? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;

  // ── Login ─────────────────────────────────────────────────────────────────
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate network delay — replace with real API call
      await Future.delayed(const Duration(seconds: 2));

      if (email.isNotEmpty && password.length >= 6) {
        _isAuthenticated = true;
        _currentUser = DummyData.currentUser;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Invalid credentials. Please try again.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ── Register ──────────────────────────────────────────────────────────────
  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
    required String phone,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));

      _isAuthenticated = true;
      _currentUser = UserModel(
        id: 'user_new',
        fullName: fullName,
        email: email,
        phone: phone,
        address: 'Barangay Pampang, Angeles City',
        birthDate: '',
        bloodType: '',
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Registration failed. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ── Logout ────────────────────────────────────────────────────────────────
  // Returns true on success, false on failure.
  // Sets _isLoggingOut during the async operation so the UI can show a spinner.
  // Clears ALL session state so no stale data is ever shown after re-login.
  Future<bool> logout() async {
    _isLoggingOut = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate a network/cleanup delay — replace with real API call
      // e.g. invalidate refresh token on server, clear secure storage, etc.
      await Future.delayed(const Duration(milliseconds: 800));

      // ── Clear every piece of session state ──
      _isAuthenticated = false;
      _currentUser = null;
      _errorMessage = null;
      _isLoggingOut = false;

      // Notify AFTER all state is cleared so the auth gate in main.dart
      // replaces MainShell with LoginScreen in a single frame — no flicker.
      notifyListeners();
      return true;
    } catch (e) {
      // Even if the server call fails we still clear local state so the
      // user is never stuck in a broken authenticated session.
      _isAuthenticated = false;
      _currentUser = null;
      _errorMessage =
          'Logout encountered an issue, but you have been signed out.';
      _isLoggingOut = false;
      notifyListeners();
      return false;
    }
  }
}
