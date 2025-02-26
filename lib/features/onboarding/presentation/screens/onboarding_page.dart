import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'onboarding_screen.dart';
import 'onboarding_screen2.dart';
import 'onboarding_screen3.dart';

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
    // TODO: Implement Apple Sign In
    print('Apple Sign In tapped');
  }

  void _handleGoogleSignIn() {
    // TODO: Implement Google Sign In
    print('Google Sign In tapped');
  }

  void _handleEmailSignIn() {
    // TODO: Implement Email Sign In
    print('Email Sign In tapped');
  }

  void _handleSkip() {
    // Navigate directly to home page, skipping the rest of onboarding
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        ],
      ),
    );
  }
} 