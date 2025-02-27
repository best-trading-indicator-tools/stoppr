import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'models/app_user.dart';

// Authentication result model
class AuthResult {
  final AppUser? user;
  final String? errorMessage;

  AuthResult({this.user, this.errorMessage});
}

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  final StreamController<AppUser?> _userStreamController = StreamController<AppUser?>.broadcast();

  AppUser? _currentUser;
  
  AuthService() {
    // Listen to Firebase auth state changes and convert to AppUser
    _firebaseAuth.authStateChanges().listen((firebaseUser) {
      if (firebaseUser != null) {
        _currentUser = AppUser.fromFirebaseUser(firebaseUser);
        _userStreamController.add(_currentUser);
      } else {
        _currentUser = null;
        _userStreamController.add(null);
      }
    });
  }

  // Stream of auth state changes
  Stream<AppUser?> get authStateChanges => _userStreamController.stream;

  // Get current user
  AppUser? get currentUser => _currentUser;

  // Sign in with Google
  Future<AuthResult> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        return AuthResult(errorMessage: 'Google sign in cancelled');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the credential
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      
      if (userCredential.user != null) {
        final user = AppUser.fromFirebaseUser(userCredential.user!);
        return AuthResult(user: user);
      }
      
      return AuthResult(errorMessage: 'Failed to sign in with Google');
    } catch (e) {
      return AuthResult(errorMessage: 'Google sign in error: ${e.toString()}');
    }
  }

  // Sign in with Apple
  Future<AuthResult> signInWithApple() async {
    try {
      // Generate nonce
      final rawNonce = _generateRandomString();
      final nonce = _sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Create an OAuthCredential from the credential
      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in with the credential
      final userCredential = await _firebaseAuth.signInWithCredential(oauthCredential);
      
      if (userCredential.user != null) {
        // Save the user name if available
        if (appleCredential.givenName != null && 
            appleCredential.familyName != null && 
            userCredential.user!.displayName == null) {
          await userCredential.user!.updateDisplayName(
            '${appleCredential.givenName} ${appleCredential.familyName}'
          );
        }
        
        final user = AppUser.fromFirebaseUser(userCredential.user!);
        return AuthResult(user: user);
      }
      
      return AuthResult(errorMessage: 'Failed to sign in with Apple');
    } catch (e) {
      // Simply return without error for any kind of cancellation or popup closing
      if (e is SignInWithAppleAuthorizationException && e.code == AuthorizationErrorCode.canceled) {
        return AuthResult();
      }
      
      // Also catch the iOS native cancellation
      if (e.toString().contains("The operation couldn't be completed")) {
        return AuthResult();
      }
      
      // Only show errors for actual failures
      if (e is FirebaseAuthException) {
        return AuthResult(errorMessage: _getReadableAuthError(e));
      }
      
      // Log the error for debugging but don't show to user
      debugPrint('Apple sign in error: ${e.toString()}');
      return AuthResult();
    }
  }

  // Sign in with email and password
  Future<AuthResult> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user != null) {
        final user = AppUser.fromFirebaseUser(userCredential.user!);
        return AuthResult(user: user);
      }
      
      return AuthResult(errorMessage: 'Failed to sign in');
    } on FirebaseAuthException catch (e) {
      return AuthResult(errorMessage: _getReadableAuthError(e));
    } catch (e) {
      return AuthResult(errorMessage: 'Error signing in: ${e.toString()}');
    }
  }

  // Sign up with email and password
  Future<AuthResult> signUpWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user != null) {
        final user = AppUser.fromFirebaseUser(userCredential.user!);
        return AuthResult(user: user);
      }
      
      return AuthResult(errorMessage: 'Failed to create account');
    } on FirebaseAuthException catch (e) {
      return AuthResult(errorMessage: _getReadableAuthError(e));
    } catch (e) {
      return AuthResult(errorMessage: 'Error creating account: ${e.toString()}');
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

  // Helper for Apple sign in to generate a random string
  String _generateRandomString() {
    final random = DateTime.now().millisecondsSinceEpoch.toString();
    return base64Url.encode(utf8.encode(random));
  }

  // Helper for Apple sign in to generate SHA256 hash
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Helper to convert Firebase auth errors to user-friendly messages
  String _getReadableAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'An account already exists with this email address';
      case 'weak-password':
        return 'Password is too weak. Please use a stronger password';
      case 'invalid-email':
        return 'Invalid email address format';
      case 'account-exists-with-different-credential':
        return 'An account already exists with the same email but different sign-in method';
      case 'invalid-credential':
        return 'The authentication credential is invalid';
      case 'operation-not-allowed':
        return 'This operation is not allowed';
      case 'user-disabled':
        return 'This user account has been disabled';
      case 'too-many-requests':
        return 'Too many sign-in attempts. Please try again later';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection';
      case 'credential-already-in-use':
        return 'This credential is already associated with another account';
      default:
        return e.message ?? 'An unknown error occurred';
    }
  }

  // Dispose to prevent memory leaks
  void dispose() {
    _userStreamController.close();
  }
} 