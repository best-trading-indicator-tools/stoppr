# Authentication Feature

This feature provides email/password authentication functionality for the Stoppr app, complementing the existing Google and Apple sign-in methods.

## Structure

- **presentation/**
  - **screens/**
    - `email_auth_screen.dart` - UI for email/password sign-in and sign-up
    - `email_auth_test.dart` - Tests for the email authentication screen

## Integration

The email authentication feature is integrated with the existing authentication system:

1. It uses the existing `AuthCubit` and `AuthService` from `lib/core/auth/`
2. It's accessible from the onboarding flow via the "Continue with Email" button
3. It supports both sign-in and sign-up functionality with form validation

## Features

- Toggle between sign-in and sign-up modes
- Form validation for:
  - Email format validation
  - Password length validation (minimum 6 characters)
  - Password matching validation (for sign-up)
- Error handling for Firebase authentication errors
- Loading state indication during authentication
- Password visibility toggle

## Usage

The `EmailAuthScreen` can be navigated to from any part of the app:

```dart
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => EmailAuthScreen(
      onBackPressed: () => Navigator.of(context).pop(),
    ),
  ),
);
```

## Error Handling

Authentication errors are handled in three ways:

1. Form validation errors are displayed inline
2. Firebase authentication errors related to email or password are displayed in the respective form fields
3. General authentication errors are displayed in a SnackBar with a selectable text widget for better visibility and debugging 