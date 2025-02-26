import 'package:flutter/material.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xFFFFD5D6),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            // Cake Image
            Image.asset(
              'assets/images/onboarding/cake-onboarding-screen-3.png',
              width: MediaQuery.of(context).size.width * 0.45,
              height: MediaQuery.of(context).size.width * 0.45,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            // White Container with Buttons
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),
                      const Text(
                        'Become a Stoppr',
                        style: TextStyle(
                          fontFamily: 'ElzaRound',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A051D),
                          letterSpacing: -0.02 * 28,
                        ),
                      ),
                      const SizedBox(height: 28),
                      // Apple Sign In Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton(
                          onPressed: onContinueWithApple,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF1A051D), width: 1.0),
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
                                size: 20,
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
                      const SizedBox(height: 12),
                      // Google Sign In Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton(
                          onPressed: onContinueWithGoogle,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF1A051D), width: 1.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            backgroundColor: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                alignment: Alignment.center,
                                child: const Text(
                                  'G',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
                      const SizedBox(height: 12),
                      // Email Sign In Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton(
                          onPressed: onContinueWithEmail,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF1A051D), width: 1.0),
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
                                size: 20,
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
                      const Spacer(),
                      // Skip Button - Purple with arrow
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3A1355),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: TextButton(
                          onPressed: onSkip,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Skip for now',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Skip hint text
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Want to skip this step? ',
                            style: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 13,
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
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 