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
    // Get the device screen size
    final screenSize = MediaQuery.of(context).size;
    
    // Calculate screen aspect ratio
    final screenRatio = screenSize.width / screenSize.height;
    
    // Target Figma dimensions
    const figmaWidth = 375.0;
    const figmaHeight = 812.0;
    const figmaRatio = figmaWidth / figmaHeight;
    
    // Determine optimal alignment based on device type
    // The wider the screen, the more we need to shift right
    double alignmentX;
    
    if (screenRatio >= 0.75) {
      // iPad and wider devices
      alignmentX = 0.6;
    } else if (screenRatio >= 0.65) {
      // iPhone Plus models in landscape
      alignmentX = 0.5;
    } else if (screenRatio >= 0.55) {
      // Standard iPhone models
      alignmentX = 0.4;
    } else {
      // Narrow screens
      alignmentX = 0.3;
    }
    
    // Debug information
    debugPrint('Screen size: $screenSize, ratio: $screenRatio, alignmentX: $alignmentX');
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: _controller.value.isInitialized
          ? Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black,
              child: ClipRect(
                child: OverflowBox(
                  alignment: Alignment.centerRight, // Base alignment to right
                  maxWidth: double.infinity,
                  maxHeight: double.infinity,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    alignment: Alignment(alignmentX, 0), // Dynamic horizontal alignment
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
    );
  }
}
