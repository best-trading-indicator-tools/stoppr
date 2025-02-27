import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth_service.dart';
import 'auth_state.dart';
import '../models/app_user.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;
  late final StreamSubscription<AppUser?> _authSubscription;

  AuthCubit({required AuthService authService}) 
      : _authService = authService, 
        super(const AuthState.initial()) {
    // Listen to auth state changes from the service
    _authSubscription = _authService.authStateChanges.listen((user) {
      if (user != null) {
        emit(AuthState.authenticated(user));
      } else {
        emit(const AuthState.unauthenticated());
      }
    });
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    emit(const AuthState.loading());
    final result = await _authService.signInWithGoogle();
    
    if (result.errorMessage != null) {
      emit(AuthState.error(result.errorMessage!));
    }
    // No need to emit authenticated state as the stream will handle that
  }

  // Sign in with Apple
  Future<void> signInWithApple() async {
    emit(const AuthState.loading());
    final result = await _authService.signInWithApple();
    
    if (result.errorMessage != null) {
      emit(AuthState.error(result.errorMessage!));
    }
    // No need to emit authenticated state as the stream will handle that
  }

  // Sign in with email and password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    emit(const AuthState.loading());
    final result = await _authService.signInWithEmailAndPassword(email, password);
    
    if (result.errorMessage != null) {
      emit(AuthState.error(result.errorMessage!));
    }
    // No need to emit authenticated state as the stream will handle that
  }

  // Sign up with email and password
  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    emit(const AuthState.loading());
    final result = await _authService.signUpWithEmailAndPassword(email, password);
    
    if (result.errorMessage != null) {
      emit(AuthState.error(result.errorMessage!));
    }
    // No need to emit authenticated state as the stream will handle that
  }

  // Sign out
  Future<void> signOut() async {
    emit(const AuthState.loading());
    await _authService.signOut();
    // The stream will handle the unauthenticated state
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
} 