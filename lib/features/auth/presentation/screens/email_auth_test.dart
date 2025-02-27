import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import '../../../../core/auth/cubit/auth_cubit.dart';
import '../../../../core/auth/cubit/auth_state.dart';
import 'email_auth_screen.dart';

@GenerateMocks([AuthCubit])
void main() {
  group('EmailAuthScreen', () {
    late MockAuthCubit mockAuthCubit;

    setUp(() {
      mockAuthCubit = MockAuthCubit();
      when(mockAuthCubit.state).thenReturn(const AuthState.initial());
    });

    testWidgets('renders sign in form by default', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthCubit>.value(
            value: mockAuthCubit,
            child: const EmailAuthScreen(),
          ),
        ),
      );

      expect(find.text('Sign In'), findsWidgets);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsNothing);
    });

    testWidgets('toggles between sign in and sign up', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthCubit>.value(
            value: mockAuthCubit,
            child: const EmailAuthScreen(),
          ),
        ),
      );

      // Initially in sign in mode
      expect(find.text('Sign Up'), findsOneWidget);
      
      // Tap to switch to sign up mode
      await tester.tap(find.text('Sign Up'));
      await tester.pump();
      
      // Now in sign up mode
      expect(find.text('Create Account'), findsWidgets);
      expect(find.text('Confirm Password'), findsOneWidget);
    });

    testWidgets('validates email format', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthCubit>.value(
            value: mockAuthCubit,
            child: const EmailAuthScreen(),
          ),
        ),
      );

      // Enter invalid email
      await tester.enterText(find.byType(TextFormField).first, 'invalid-email');
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      
      // Tap sign in button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      
      // Should show validation error
      expect(find.text('Please enter a valid email address'), findsOneWidget);
    });

    testWidgets('validates password length', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthCubit>.value(
            value: mockAuthCubit,
            child: const EmailAuthScreen(),
          ),
        ),
      );

      // Enter valid email but short password
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(1), '123');
      
      // Tap sign in button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      
      // Should show validation error
      expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    testWidgets('calls signInWithEmailAndPassword when form is valid', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthCubit>.value(
            value: mockAuthCubit,
            child: const EmailAuthScreen(),
          ),
        ),
      );

      // Enter valid credentials
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      
      // Tap sign in button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      
      // Verify cubit method was called
      verify(mockAuthCubit.signInWithEmailAndPassword('test@example.com', 'password123')).called(1);
    });
  });
} 