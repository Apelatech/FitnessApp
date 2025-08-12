import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:apelatech_fitness/core/services/user_database_service.dart';
import 'package:apelatech_fitness/shared/models/app_user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final UserDatabaseService _userDatabase = UserDatabaseService();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get user data from database
  Future<AppUser?> getUserData(String uid) async {
    return await _userDatabase.getUser(uid);
  }

  // Sign in with email and password and sync with database
  Future<UserCredential?> signInWithEmailPassword(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update last sign in time and ensure user exists in database
      if (credential.user != null) {
        await _userDatabase.updateLastSignIn(credential.user!.uid);
        
        // Ensure user exists in database
        final userExists = await _userDatabase.userExists(credential.user!.uid);
        if (!userExists) {
          final appUser = AppUser.fromFirebaseUser(credential.user!);
          await _userDatabase.createUser(appUser);
        }
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      if (e.toString().contains('network') || 
          e.toString().contains('timeout') ||
          e.toString().contains('host')) {
        throw 'Network error. Please check your internet connection and try again.';
      }
      throw 'Unable to connect to authentication service. Please try again later.';
    }
  }

  // Sign up with email and password and create user in database
  Future<UserCredential?> signUpWithEmailPassword(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user profile in database
      if (credential.user != null) {
        final appUser = AppUser.fromFirebaseUser(credential.user!);
        await _userDatabase.createUser(appUser);
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      if (e.toString().contains('network') || 
          e.toString().contains('timeout') ||
          e.toString().contains('host')) {
        throw 'Network error. Please check your internet connection and try again.';
      }
      throw 'Unable to connect to authentication service. Please try again later.';
    }
  }

  // Sign in with Google and sync with database
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        return null; // User cancelled the sign-in
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await _auth.signInWithCredential(credential);

      // Create or update user in database
      if (userCredential.user != null) {
        await _userDatabase.updateLastSignIn(userCredential.user!.uid);
        
        final userExists = await _userDatabase.userExists(userCredential.user!.uid);
        if (!userExists) {
          final appUser = AppUser.fromFirebaseUser(userCredential.user!);
          await _userDatabase.createUser(appUser);
        }
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw 'Google sign-in failed. Please try again.';
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw 'Sign out failed. Please try again.';
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw 'Failed to send password reset email. Please try again.';
    }
  }

  // Update user profile
  Future<void> updateUserProfile({String? displayName, String? photoURL}) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(displayName);
        await user.updatePhotoURL(photoURL);
        
        // Update in database as well
        await _userDatabase.updateUserProfile(user.uid, {
          'displayName': displayName,
          'photoURL': photoURL,
        });
      }
    } catch (e) {
      throw 'Failed to update profile. Please try again.';
    }
  }

  // Delete user account
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Delete from database first
        await _userDatabase.deleteUser(user.uid);
        // Then delete Firebase auth account
        await user.delete();
      }
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw 'Failed to delete account. Please try again.';
    }
  }

  // Reload current user
  Future<void> reloadUser() async {
    await _auth.currentUser?.reload();
  }

  // Send email verification
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw 'Failed to send verification email. Please try again.';
    }
  }

  // Handle Firebase Auth exceptions
  String _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      case 'weak-password':
        return 'Password is too weak. Please choose a stronger password.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'invalid-credential':
        return 'Invalid credentials. Please check your email and password.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with the same email but different sign-in credentials.';
      case 'requires-recent-login':
        return 'This operation requires recent authentication. Please sign in again.';
      default:
        return 'Authentication failed: ${e.message ?? 'Unknown error'}';
    }
  }
}
