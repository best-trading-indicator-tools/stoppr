import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/app_user.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  // Initial state
  const factory AuthState.initial() = Initial;

  // Loading state (during auth operations)
  const factory AuthState.loading() = Loading;

  // User is authenticated
  const factory AuthState.authenticated(AppUser user) = Authenticated;

  // User is not authenticated
  const factory AuthState.unauthenticated() = Unauthenticated;

  // Error state
  const factory AuthState.error(String message) = Error;
} 