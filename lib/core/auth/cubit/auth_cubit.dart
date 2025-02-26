import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;
  StreamSubscription<User?>? _authStateSubscription;

  AuthCubit({required AuthService authService}) 
      : _authService = authService,
        super(const AuthState.initial()) {
    // Listen to auth state changes
    _authStateSubscription = _authService.authStateChanges.listen((user) {
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
    
    if (result.isSuccess && result.user != null) {
      emit(AuthState.authenticated(result.user!));
    } else {
      emit(AuthState.error(result.errorMessage ?? 'Unknown error occurred'));
    }
  }

  // Sign out
  Future<void> signOut() async {
    emit(const AuthState.loading());
    
    try {
      await _authService.signOut();
      emit(const AuthState.unauthenticated());
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
} 