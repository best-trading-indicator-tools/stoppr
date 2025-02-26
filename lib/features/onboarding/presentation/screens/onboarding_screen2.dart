import 'package:flutter/material.dart';

class OnboardingScreen2 extends StatelessWidget {
  final VoidCallback onStartQuiz;
  
  const OnboardingScreen2({
    super.key, 
    required this.onStartQuiz,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF97777), // Top gradient color
      body: Stack(
        children: [
          // Background gradient image with sunset
          Container(
            color: const Color(0xFFF97777),
            child: Image.asset(
              'assets/images/onboarding/sun-image-background.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          
          // Content
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 1),
                
                // Stoppr title and subtitle
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Text(
                        'Stoppr',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Quit sugar once and for all',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const Spacer(flex: 4),
                
                // White card at bottom
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 24.0,
                      right: 24.0,
                      top: 40.0,
                      bottom: 40.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Text at the top of the card
                        const Text(
                          'Let\'s find out if you have a problem with sugar',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A051D), // Dark purple/black
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        
                        // Start Quiz button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: onStartQuiz,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3A1355), // Purple color
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Start Quiz',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward_ios, size: 16),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Rating stars and satisfaction
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // 5 stars
                            ...List.generate(5, (index) => 
                              const Icon(
                                Icons.star, 
                                color: Color(0xFFFFAA42), // Orange
                                size: 24,
                              )
                            ),
                            const SizedBox(width: 8),
                            // Satisfaction text
                            const Text(
                              '98% Satisfaction',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A051D),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 