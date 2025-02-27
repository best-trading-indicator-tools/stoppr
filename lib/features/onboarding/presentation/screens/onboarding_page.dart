import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/auth/cubit/auth_cubit.dart';
import '../../../../core/auth/cubit/auth_state.dart';
import 'onboarding_screen.dart';
import 'onboarding_screen2.dart';
import 'onboarding_screen3.dart';
import '../../../../features/auth/presentation/screens/email_auth_screen.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToNext() {
    if (_currentPage < 2) {
      setState(() {
        _currentPage++;
      });
      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleAppleSignIn() {
    context.read<AuthCubit>().signInWithApple();
  }

  void _handleGoogleSignIn() {
    context.read<AuthCubit>().signInWithGoogle();
  }

  void _handleEmailSignIn() {
    // Navigate to the email authentication screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EmailAuthScreen(
          onBackPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  void _handleSkip() {
    // Navigate directly to home page, skipping the rest of onboarding
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          authenticated: (_) {
            // Navigate to home page on successful authentication
            Navigator.of(context).pushReplacementNamed('/home');
          },
          error: (message) {
            // Show error message with user-friendly handling
            String displayMessage = message;
            
            // Convert technical errors to user-friendly messages
            if (message == 'Sign in cancelled') {
              // Don't show any error for user-initiated cancellation
              return;
            } else if (message.contains('network')) {
              displayMessage = 'Please check your internet connection and try again';
            }
            
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: SelectableText.rich(
                  TextSpan(
                    text: 'Authentication Error: ',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                    children: [
                      TextSpan(
                        text: displayMessage,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                backgroundColor: Colors.black87,
                duration: const Duration(seconds: 5),
              ),
            );
          },
          orElse: () {},
        );
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            PageView(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(), // Disable manual scrolling
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                // First screen - Video with candy
                OnboardingScreen(onComplete: _navigateToNext),
                
                // Second screen - Stoppr quiz screen
                OnboardingScreen2(
                  onStartQuiz: _navigateToNext,
                ),
                
                // Third screen - Authentication options
                OnboardingScreen3(
                  onContinueWithApple: _handleAppleSignIn,
                  onContinueWithGoogle: _handleGoogleSignIn,
                  onContinueWithEmail: _handleEmailSignIn,
                  onSkip: _handleSkip,
                ),
              ],
            ),
            // Show loading indicator when authenticating
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return state.maybeWhen(
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                  orElse: () => const SizedBox.shrink(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
} 