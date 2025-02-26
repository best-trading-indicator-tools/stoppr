import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingScreen2 extends StatelessWidget {
  final VoidCallback onStartQuiz;
  
  const OnboardingScreen2({
    super.key, 
    required this.onStartQuiz,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background gradient image with sunset
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/onboarding/sun-image-background.png'),
                fit: BoxFit.fitWidth,
                alignment: Alignment(0.0, -1),
              ),
            ),
          ),
          
          // Content
          Column(
            children: [
              const SizedBox(height: 150), // Increased from 80 to 120 to move content down
              
              // Stoppr title and subtitle
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Text(
                      'Stoppr',
                      style: TextStyle(
                        fontFamily: 'ElzaRound',
                        color: Colors.white,
                        fontSize: 56.03,
                        fontWeight: FontWeight.bold,
                        height: 1.0, // 100% line height
                        letterSpacing: -0.04 * 56.03, // -4% of font size
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Quit sugar once and for all',
                      style: TextStyle(
                        fontFamily: 'ElzaRound',
                        color: const Color.fromRGBO(255, 255, 255, 0.6),
                        fontSize: 21.01,
                        fontWeight: FontWeight.w500, // Medium weight
                        height: 1.0, // 100% line height
                        letterSpacing: -0.01 * 21.01, // -1% of font size
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
                          fontFamily: 'ElzaRound',
                          fontSize: 16,
                          fontWeight: FontWeight.w500, // Medium weight
                          height: 1.0, // 100% line height
                          letterSpacing: 0, // 0% letter spacing
                          color: Color(0xFF181830),
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
                          // Stars SVG
                          SvgPicture.asset(
                            'assets/images/svg/stars-onboarding-screen-2.svg',
                            height: 24,
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
        ],
      ),
    );
  }
} 