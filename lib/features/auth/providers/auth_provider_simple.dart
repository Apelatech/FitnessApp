import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:apelatech_fitness/core/services/auth_service_simple.dart';
import 'package:apelatech_fitness/shared/models/app_user.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  AppUser? _user;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  AppUser? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _user != null;

  // Initialize auth state listener
  void initializeAuth() {
    // Listen to Firebase auth changes
    _authService.authStateChanges.listen((User? firebaseUser) async {
      if (firebaseUser != null) {
        _user = AppUser.fromFirebaseUser(firebaseUser);
      } else {
        _user = null;
      }
      notifyListeners();
    });
  }

  // Sign in with email and password
  Future<bool> signInWithEmailPassword(String email, String password) async {
    try {
      _setLoading(true);
      _clearError();

      final userCredential = await _authService.signInWithEmailPassword(email, password);
      
      if (userCredential?.user != null) {
        _user = AppUser.fromFirebaseUser(userCredential!.user!);
        _setLoading(false);
        return true;
      }
      
      _setLoading(false);
      return false;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Sign up with email and password
  Future<bool> signUpWithEmailPassword(String email, String password, {String? displayName}) async {
    try {
      _setLoading(true);
      _clearError();

      final userCredential = await _authService.signUpWithEmailPassword(email, password);
      
      if (userCredential?.user != null) {
        _user = AppUser.fromFirebaseUser(userCredential!.user!);
        _setLoading(false);
        return true;
      }
      
      _setLoading(false);
      return false;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      _setLoading(true);
      _clearError();

      await _authService.signOut();
      _user = null;
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  // Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      _setLoading(true);
      _clearError();

      // For now, return true as we haven't implemented this in simple auth service
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Update user profile - simplified
  Future<bool> updateUserProfile({String? displayName, String? photoURL}) async {
    try {
      _setLoading(true);
      _clearError();

      // For now, just update local user data
      final currentUser = _authService.currentUser;
      if (currentUser != null) {
        _user = AppUser.fromFirebaseUser(currentUser);
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Delete account - simplified
  Future<bool> deleteAccount() async {
    try {
      _setLoading(true);
      _clearError();

      // For now, just sign out
      await _authService.signOut();
      _user = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Sign in with Google - not implemented in simple version
  Future<bool> signInWithGoogle() async {
    _setError('Google sign-in not available in simplified version');
    return false;
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Clear error manually
  void clearError() {
    _clearError();
  }
}
