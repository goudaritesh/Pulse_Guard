import 'package:cpr_training_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async'; // For StreamSubscription and Timer
import 'package:sensors_plus/sensors_plus.dart'; // For accelerometer data
import 'package:video_player/video_player.dart'; // For video playback
import 'package:chewie/chewie.dart'; // For video player UI controls
import 'package:fl_chart/fl_chart.dart'; // For charting (though not used in this no-backend version's progress)

class FeedbackGauge extends StatelessWidget {
  final double value; // Value between 0.0 and 1.0 (e.g., depth score)
  final String label;
  final double goodRangeMin;
  final double goodRangeMax;
  final double size;

  const FeedbackGauge({
    super.key, // Use super.key
    required this.value,
    required this.label,
    this.goodRangeMin = 0.0,
    this.goodRangeMax = 1.0,
    this.size = 120, // Default size
  });

  @override
  Widget build(BuildContext context) {
    Color indicatorColor;
    if (value >= goodRangeMin && value <= goodRangeMax) {
      indicatorColor = Colors.green.shade600;
    } else if (value > goodRangeMax) {
      indicatorColor = Colors.orange.shade600; // Too much
    } else {
      indicatorColor = Colors.red.shade600; // Too little
    }

    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black87),
        ),
        const SizedBox(height: 10),
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(size / 2), // Make it circular
            border: Border.all(color: Colors.grey.shade300, width: 2),
          ),
          child: Stack(
            children: [
              // Background for the gauge
              Center(
                child: Container(
                  width: size * 0.8,
                  height: size * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(size * 0.4),
                  ),
                ),
              ),
              // Good range arc (simplified to a background color for circular gauge)
              // For a true arc, you'd use CustomPainter, but this is a quick visual.
              Center(
                child: Container(
                  width: size * 0.7,
                  height: size * 0.7,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1), // Light green background for good range
                    borderRadius: BorderRadius.circular(size * 0.35),
                  ),
                ),
              ),
              // Current value indicator (simplified to a circle within the gauge)
              Center(
                child: Container(
                  width: size * 0.6 * value.clamp(0.0, 1.0), // Scale size based on value
                  height: size * 0.6 * value.clamp(0.0, 1.0),
                  decoration: BoxDecoration(
                    color: indicatorColor,
                    borderRadius: BorderRadius.circular(size * 0.3),
                  ),
                ),
              ),
              Center(
                child: Text(
                  '${(value * 100).toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.black, // Text color for value
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}