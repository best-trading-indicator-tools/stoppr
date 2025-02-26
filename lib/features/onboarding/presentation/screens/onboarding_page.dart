import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'onboarding_screen.dart';

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
    } else {
      // Navigate to home page when completed
      Navigator.of(context).pushReplacementNamed('/home');
    }
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
              // First screen - Video
              OnboardingScreen(onComplete: _navigateToNext),
              
              // Second screen - Placeholder
              Container(
                color: Colors.black,
                child: const Center(
                  child: Text(
                    'Onboarding Screen 2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              
              // Third screen - Placeholder
              Container(
                color: Colors.black,
                child: const Center(
                  child: Text(
                    'Onboarding Screen 3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          // Dots indicator
          Container(
            alignment: const Alignment(0, 0.85),
            child: SmoothPageIndicator(
              controller: _controller,
              count: 3,
              effect: const ExpandingDotsEffect(
                spacing: 8,
                dotWidth: 8,
                dotHeight: 8,
                dotColor: Colors.white38,
                activeDotColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 