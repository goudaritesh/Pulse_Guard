import 'package:flutter/material.dart';
import 'dart:async'; // For StreamSubscription and Timer
import 'package:sensors_plus/sensors_plus.dart'; // For accelerometer and gyroscope data
import 'package:video_player/video_player.dart'; // For video playback
import 'package:chewie/chewie.dart'; // For video player UI controls
import 'package:fl_chart/fl_chart.dart';
import '../models/patient_profile.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
// For displaying line charts

class CprAnalyzer {
  StreamSubscription? _accelerometerSubscription;
  final _cprDataController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get cprDataStream => _cprDataController.stream;

  // Patient profile and CPR type to adjust parameters
  final PatientProfile patientProfile;
  final String cprType; // e.g., 'Adult CPR', 'Child CPR', 'Rhythm Challenge'

  // CPR Guideline Parameters (Adjusted based on ageCategory and cprType)
  double _optimalRateMin = 100.0;
  double _optimalRateMax = 120.0;
  double _minDepthPeakThreshold = 15.0; // Minimum acceleration to count as a compression
  double _optimalDepthPeakThreshold = 25.0; // Optimal acceleration for "good" depth
  double _recoilThreshold = 5.0; // Z-axis value must drop below this after a peak
  double _maxDepthCm = 5.0; // Max depth in CM for visualization scaling (Adult)

  // Declare missing fields here
  DateTime? _lastCompressionPeakTime;
  final List<double> _compressionIntervals = []; // Store recent intervals
  final int _maxIntervals = 5; // Number of intervals to average for rate

  // State for detecting a full compression cycle
  bool _isCompressing = false;
  double _peakZ = 0.0;

  CprAnalyzer({required this.patientProfile, required this.cprType}) {
    _setCprParameters();
  }

  void _setCprParameters() {
    // Default to Adult CPR guidelines
    _optimalRateMin = 100.0;
    _optimalRateMax = 120.0;
    _minDepthPeakThreshold = 15.0; // Adult: approx 5-6cm depth
    _optimalDepthPeakThreshold = 25.0; // Adult: approx 5-6cm depth
    _recoilThreshold = 5.0;
    _maxDepthCm = 6.0; // Max depth for adults is 6cm

    if (cprType == 'Child CPR' || patientProfile.ageCategory == 'Child (1-17 yrs)') {
      // American Heart Association (AHA) guidelines for Child CPR (1 year to puberty)
      // Rate: 100-120 compressions/min (same as adult)
      // Depth: About 2 inches (5 cm)
      _optimalRateMin = 100.0;
      _optimalRateMax = 120.0;
      _minDepthPeakThreshold = 12.0; // Adjusted for child (less force/depth)
      _optimalDepthPeakThreshold = 20.0; // Adjusted for child
      _maxDepthCm = 5.0; // Max depth for children is 5cm
    }
    // You can add more conditions for 'Seniors' if their guidelines differ significantly
    // or for 'Infant' if you add that category.
    // For 'Rhythm Challenge', the depth thresholds might be less strict or ignored.
  }

  bool isRateOptimal(double rate) {
    return rate >= _optimalRateMin && rate <= _optimalRateMax;
  }

  double get optimalDepthScoreThreshold => (_optimalDepthPeakThreshold / _optimalDepthPeakThreshold).clamp(0.0, 1.0);

  double getDepthInCm(double simulatedDepthScore) {
    // Scale the 0-1 simulated score to a realistic CM range based on maxDepthCm
    return simulatedDepthScore * _maxDepthCm;
  }


  void startAnalysis(Stream<AccelerometerEvent> accelerometerStream) {
    _accelerometerSubscription = accelerometerStream.listen((event) {
      _processAccelerometerData(event);
    });
  }

  void _processAccelerometerData(AccelerometerEvent event) {
    // We are interested in the Z-axis for vertical motion (assuming phone is flat on chest)
    double z = event.z;

    // --- Compression Detection and Rate Calculation ---
    // Detect the start of a compression (downward push)
    if (z > _minDepthPeakThreshold && !_isCompressing) {
      _isCompressing = true;
      _peakZ = z; // Store the initial peak for this compression
    } else if (_isCompressing && z > _peakZ) {
      // Update peak if a higher acceleration is detected during the compression
      _peakZ = z;
    }

    // Detect the end of a compression and potential recoil
    if (_isCompressing && z < _recoilThreshold && _peakZ > _minDepthPeakThreshold) {
      // This signifies a potential full compression and recoil
      _isCompressing = false; // Reset for next compression

      DateTime now = DateTime.now();
      if (_lastCompressionPeakTime != null) {
        final intervalMs = now.difference(_lastCompressionPeakTime!).inMilliseconds;

        // Add to intervals and maintain max size
        _compressionIntervals.add(intervalMs.toDouble());
        if (_compressionIntervals.length > _maxIntervals) {
          _compressionIntervals.removeAt(0);
        }

        // Calculate average rate
        double averageIntervalMs = _compressionIntervals.reduce((a, b) => a + b) / _compressionIntervals.length;
        double currentRate = 60000 / averageIntervalMs; // Compressions per minute

        // --- Simulated Depth Score Calculation ---
        // Higher peakZ means more "force" or "depth" in this simplified model
        double simulatedDepthScore = (_peakZ / _optimalDepthPeakThreshold).clamp(0.0, 1.0);

        // --- Feedback Generation ---
        String feedback = _getFeedback(currentRate, simulatedDepthScore);

        // Emit processed data
        _cprDataController.add({
          'rate': currentRate,
          'simulatedDepthScore': simulatedDepthScore,
          'feedback': feedback,
        });
      }
      _lastCompressionPeakTime = now; // Update last peak time for the next interval
      _peakZ = 0.0; // Reset peak Z for the next compression
    }
  }

  String _getFeedback(double rate, double depthScore) {
    String rateFeedback = '';
    String depthFeedback = '';

    if (isRateOptimal(rate)) {
      rateFeedback = 'Good Rate!';
    } else if (rate < _optimalRateMin && rate > 0) {
      rateFeedback = 'Push Faster!';
    } else if (rate > _optimalRateMax) {
      rateFeedback = 'Push Slower!';
    }

    if (depthScore >= optimalDepthScoreThreshold) { // Assuming 0.8 to 1.0 is good depth
      depthFeedback = 'Good Depth!';
    } else if (depthScore < optimalDepthScoreThreshold && depthScore > 0) {
      depthFeedback = 'Push Deeper!';
    }

    if (rateFeedback.isEmpty && depthFeedback.isEmpty) {
      return "Start compressions...";
    } else if (rateFeedback.isNotEmpty && depthFeedback.isNotEmpty) {
      if (rateFeedback == 'Good Rate!' && depthFeedback == 'Good Depth!') {
        return 'Excellent!';
      }
      return '$rateFeedback $depthFeedback';
    } else if (rateFeedback.isNotEmpty) {
      return rateFeedback;
    } else {
      return depthFeedback;
    }
  }

  void stopAnalysis() {
    _accelerometerSubscription?.cancel();
    _lastCompressionPeakTime = null;
    _compressionIntervals.clear();
    _isCompressing = false;
    _peakZ = 0.0;
  }

  void dispose() {
    _cprDataController.close();
    stopAnalysis();
  }
}
