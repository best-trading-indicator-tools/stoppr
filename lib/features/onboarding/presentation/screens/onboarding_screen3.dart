import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingScreen3 extends StatelessWidget {
  final VoidCallback? onContinueWithApple;
  final VoidCallback? onContinueWithGoogle;
  final VoidCallback? onContinueWithEmail;
  final VoidCallback? onSkip;
  
  const OnboardingScreen3({
    super.key,
    this.onContinueWithApple,
    this.onContinueWithGoogle,
    this.onContinueWithEmail,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cakeSize = screenSize.width * 0.78;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            color: const Color(0xFFFFD5D6),
            width: double.infinity,
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  SizedBox(height: screenSize.height * 0.03),
                  Image.asset(
                    'assets/images/onboarding/cake-onboarding-screen-3.png',
                    width: cakeSize,
                    height: cakeSize,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Become a Stoppr',
                        style: TextStyle(
                          fontFamily: 'ElzaRound',
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A051D),
                          letterSpacing: -0.02 * 25,
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.03),
                      Container(
                        width: screenSize.width * 0.85,
                        height: 56,
                        child: OutlinedButton(
                          onPressed: onContinueWithApple,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF1A051D), width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            backgroundColor: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.apple,
                                color: Colors.black,
                                size: 25,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Continue with Apple',
                                style: TextStyle(
                                  color: Color(0xFF1A051D),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: screenSize.width * 0.85,
                        height: 56,
                        child: OutlinedButton(
                          onPressed: onContinueWithGoogle,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF1A051D), width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            backgroundColor: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/icons/google_g_logo.svg',
                                width: 25,
                                height: 25,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Continue with Google',
                                style: TextStyle(
                                  color: Color(0xFF1A051D),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: screenSize.width * 0.85,
                        height: 56,
                        child: OutlinedButton(
                          onPressed: onContinueWithEmail,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF1A051D), width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            backgroundColor: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.email_outlined,
                                color: Color(0xFF1A051D),
                                size: 25,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Continue with Email',
                                style: TextStyle(
                                  color: Color(0xFF1A051D),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: screenSize.width * 0.85,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: onSkip,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3A1355),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Skip for now',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: 'ElzaRound',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Want to skip this step? ',
                            style: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 13,
                              fontFamily: 'ElzaRound',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          GestureDetector(
                            onTap: onSkip,
                            child: const Text(
                              'Skip',
                              style: TextStyle(
                                color: Color(0xFF3A1355),
                                fontSize: 13,
                                fontFamily: 'ElzaRound',
                                fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 