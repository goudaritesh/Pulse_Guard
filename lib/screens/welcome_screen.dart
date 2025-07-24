import 'package:cpr_training_app/screens/training_selection_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async'; // For StreamSubscription and Timer
import 'package:sensors_plus/sensors_plus.dart'; // For accelerometer data
import 'package:video_player/video_player.dart'; // For video playback
import 'package:chewie/chewie.dart'; // For video player UI controls
import 'package:fl_chart/fl_chart.dart';

import '../widgets/gradient_button.dart';
import '../widgets/video_player_widget.dart'; // For charting (though not used in this no-backend version's progress)

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key}); // Use super.key

  @override
  Widget build(BuildContext context) {
    // Placeholder video URL for demonstration.
    // Replace with your actual introductory animated video URL.
    const String introVideoUrl = 'assets/videos/cpr.mp4';

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            // Heart Icon - Using a simple icon for now. For 3D, you'd use a custom painter or asset.
            const Icon(
              Icons.favorite,
              color: Colors.pinkAccent,
              size: 100,
            ),
            const SizedBox(height: 30),
            Text(
              'Welcome to PulseGuard',
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            Text(
              'Learn life-saving CPR skills with real-time feedback using your phone\'s sensors.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            // Video Preview (Optional, can be removed if you prefer just text)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: VideoPlayerWidget(
                videoUrl: introVideoUrl,
                autoPlay: false, // Don't autoplay on welcome
                looping: false,
                aspectRatio: 16 / 9,
              ),
            ),
            const SizedBox(height: 30),
            GradientButton(
              text: 'Get Started',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const TrainingSelectionScreen()),
                );
              },
            ),
            const SizedBox(height: 15),
            OutlinedButton(
              onPressed: () {
                // If skipping tutorial means directly going to training selection
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const TrainingSelectionScreen()),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF3F51B5), width: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                minimumSize: const Size(double.infinity, 55),
              ),
              child: Text(
                'Skip Tutorial',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: const Color(0xFF3F51B5)),
              ),
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
