import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;
  
  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late VideoPlayerController _controller;
  late Timer _videoTimer;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.asset('assets/videos/onboarding-1-video.mp4')
      ..setLooping(false) // No looping as we'll navigate away
      ..initialize().then((_) {
        // Ensure the first frame is shown and start playing
        if (mounted) {
          setState(() {});
          _controller.play();
          
          // Set a timer to navigate to next screen after 3 seconds
          _videoTimer = Timer(const Duration(seconds: 3), () {
            if (mounted) {
              widget.onComplete();
            }
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    if (_videoTimer.isActive) {
      _videoTimer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _controller.value.isInitialized
          ? Stack(
              children: [
                // Video background
                SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
                // Playstore image overlay positioned where the sun is
                Positioned(
                  right: 10,
                  bottom: MediaQuery.of(context).size.height * 0.2, // Position it where the sun is
                  width: 100, // Adjust size as needed
                  height: 100, // Adjust size as needed
                  child: Image.asset(
                    'assets/images/logo/playstore.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
    );
  }
}
