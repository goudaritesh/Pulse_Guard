import 'package:cpr_training_app/screens/cpr_training_screen.dart';
import 'package:cpr_training_app/screens/training_selection_screen.dart';
import 'package:cpr_training_app/widgets/video_player_widget.dart';
import 'package:flutter/material.dart';
import 'dart:async'; // For StreamSubscription and Timer
import 'package:sensors_plus/sensors_plus.dart'; // For accelerometer data
import 'package:video_player/video_player.dart'; // For video playback
import 'package:chewie/chewie.dart'; // For video player UI controls
import 'package:fl_chart/fl_chart.dart'; // For charting (though not used in this no-backend version's progress)


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key}); // Use super.key

  @override
  Widget build(BuildContext context) {
    // Placeholder video URL for demonstration.
    // Replace with your actual introductory animated video URL.
    const String introVideoUrl = 'assets/videos/cpr.mp4';
    // For local assets, add to pubspec.yaml and use 'asset:assets/videos/intro.mp4'

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart CPR Trainer'),
        centerTitle: true,
      ),
      body: SingleChildScrollView( // Use SingleChildScrollView for better responsiveness
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Introductory Video Section
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Welcome to CPR Trainer!',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: VideoPlayerWidget(
                          videoUrl: introVideoUrl,
                          autoPlay: false, // Don't autoplay on home screen
                          looping: false,
                          aspectRatio: 16 / 9,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Watch this quick intro to get started.',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  // Corrected navigation: Go to TrainingSelectionScreen first
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TrainingSelectionScreen()),
                  );
                },
                icon: const Icon(Icons.fitness_center, size: 30),
                label: const Text('Start CPR Training'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.green.shade600,
                  minimumSize: const Size(double.infinity, 60), // Full width button
                  elevation: 8,
                ),
              ),
              const SizedBox(height: 20),
              // Removed "View Progress" button as there's no backend to store progress
            ],
          ),
        ),
      ),
    );
  }
}
