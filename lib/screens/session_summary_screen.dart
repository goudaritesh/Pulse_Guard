import 'package:cpr_training_app/screens/training_selection_screen.dart';
import 'package:cpr_training_app/services/sensor_service.dart';
import 'package:cpr_training_app/widgets/video_player_widget.dart' show VideoPlayerWidget;
import 'package:flutter/material.dart';
import 'dart:async'; // For StreamSubscription and Timer
import 'package:sensors_plus/sensors_plus.dart'; // For accelerometer data
import 'package:video_player/video_player.dart'; // For video playback
import 'package:chewie/chewie.dart'; // For video player UI controls
import 'package:fl_chart/fl_chart.dart';

import '../models/patient_profile.dart';
import '../services/cpr_analyzer.dart';
import '../widgets/gradient_button.dart'; // For charting (though not used in this no-backend version's progress)

class SessionSummaryScreen extends StatelessWidget {
  final double averageRate;
  final double averageDepthScore;
  final double overallScore;
  final int durationSeconds;
  final PatientProfile patientProfile; // Receive patient profile

  const SessionSummaryScreen({
    super.key, // Use super.key
    required this.averageRate,
    required this.averageDepthScore,
    required this.overallScore,
    required this.durationSeconds,
    required this.patientProfile,
  });

  String _formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    String improvementArea = '';
    if (overallScore < 50) {
      improvementArea = 'Needs more practice. Focus on consistent rate and depth for ${patientProfile.ageCategory} CPR.';
    } else if (overallScore < 80) {
      improvementArea = 'Good effort! Try to maintain consistent rhythm and full chest recoil for ${patientProfile.ageCategory} CPR.';
    } else {
      improvementArea = 'Excellent work! Keep up the great technique for ${patientProfile.ageCategory} CPR.';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Session Complete!', style: Theme.of(context).textTheme.headlineSmall),
        automaticallyImplyLeading: false, // Hide back button
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Great job on your training!',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Patient: ${patientProfile.ageCategory} (${patientProfile.gender})',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF673AB7), Color(0xFF3F51B5)], // Purple to blue gradient
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade200.withOpacity(0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    overallScore.toStringAsFixed(0),
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white, fontSize: 60),
                  ),
                  Text(
                    'Overall Score',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSummaryMetric('Avg Rate', '${averageRate.toStringAsFixed(0)}', 'per min', context),
                      _buildSummaryMetric('Avg Depth', '${(averageDepthScore * 5.0).toStringAsFixed(1)}', 'cm', context), // Scaled
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSummaryMetric('Accuracy', '${(overallScore).toStringAsFixed(0)}%', '', context), // Overall score is accuracy
                      _buildSummaryMetric('Duration', _formatDuration(durationSeconds), '', context),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: Colors.amber.shade700, size: 30),
                        const SizedBox(width: 10),
                        Text(
                          'Areas for improvement:',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      improvementArea,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            GradientButton(
              text: 'Back to Training',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const TrainingSelectionScreen()),
                );
              },
              icon: Icons.arrow_back,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryMetric(String title, String value, String unit, BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
        ),
        Text(
          '$title ${unit.isNotEmpty ? '($unit)' : ''}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
        ),
      ],
    );
  }
}
