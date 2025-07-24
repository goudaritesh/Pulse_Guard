import 'package:cpr_training_app/screens/cpr_training_screen.dart';
import 'package:cpr_training_app/services/sensor_service.dart';
import 'package:cpr_training_app/widgets/gradient_button.dart';
import 'package:cpr_training_app/widgets/video_player_widget.dart' show VideoPlayerWidget;
import 'package:flutter/material.dart';
import 'dart:async'; // For StreamSubscription and Timer
import 'package:sensors_plus/sensors_plus.dart'; // For accelerometer data
import 'package:video_player/video_player.dart'; // For video playback
import 'package:chewie/chewie.dart'; // For video player UI controls
import 'package:fl_chart/fl_chart.dart';
import '../models/patient_profile.dart';
import '../services/cpr_analyzer.dart'; // For charting (though not used in this no-backend version's progress)

class CalibrationScreen extends StatefulWidget {
  final String cprType;
  final PatientProfile patientProfile; // Pass patient profile

  const CalibrationScreen({super.key, required this.cprType, required this.patientProfile}); // Use super.key

  @override
  State<CalibrationScreen> createState() => _CalibrationScreenState();
}

class _CalibrationScreenState extends State<CalibrationScreen> {
  final SensorService _sensorService = SensorService();
  StreamSubscription? _accelerometerSubscription;
  double _currentZAcceleration = 0.0;
  bool _isCalibrating = false;
  int _calibrationStep = 1;
  Timer? _calibrationTimer;
  int _calibrationCountdown = 3; // Seconds for calibration

  @override
  void initState() {
    super.initState();
    _accelerometerSubscription = _sensorService.accelerometerStream.listen((event) {
      if (mounted) {
        setState(() {
          _currentZAcceleration = event.z;
        });
      }
    });
    _sensorService.startListening();
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _sensorService.stopListening();
    _calibrationTimer?.cancel();
    super.dispose();
  }

  void _startCalibration() {
    setState(() {
      _isCalibrating = true;
      _calibrationStep = 3; // Move to the countdown step
      _calibrationCountdown = 3;
    });

    _calibrationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_calibrationCountdown > 0) {
        setState(() {
          _calibrationCountdown--;
        });
      } else {
        timer.cancel();
        _completeCalibration();
      }
    });
  }

  void _completeCalibration() {
    // In a real app, you would save this baseline and use it in CPR analysis.
    // For this demo, it just progresses the flow.
    setState(() {
      _isCalibrating = false;
      _calibrationStep = 4; // Indicate completion or ready to proceed
    });

    // Navigate to CPR training screen after a short delay or user tap
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CprTrainingScreen(
          cprType: widget.cprType,
          patientProfile: widget.patientProfile, // Pass patient profile
        )),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calibration', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Prepare your device',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _buildCalibrationStep(
              1,
              'Place phone on training surface',
              _calibrationStep >= 1,
            ),
            _buildCalibrationStep(
              2,
              'Keep device completely still',
              _calibrationStep >= 2,
            ),
            _buildCalibrationStep(
              3,
              'Tap calibrate when ready',
              _calibrationStep >= 3,
            ),
            const SizedBox(height: 40),
            if (_isCalibrating)
              Column(
                children: [
                  LinearProgressIndicator(
                    value: 1 - (_calibrationCountdown / 3),
                    backgroundColor: Colors.grey.shade300,
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3F51B5)),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Calibrating... $_calibrationCountdown seconds remaining',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              )
            else
              GradientButton(
                text: 'Start Calibration',
                onPressed: _startCalibration,
                colors: const [Color(0xFF3F51B5), Color(0xFF673AB7)],
              ),
            const SizedBox(height: 20),
            Text(
              'Current Z-Acceleration: ${_currentZAcceleration.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildCalibrationStep(int stepNumber, String instruction, bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: isActive ? const Color(0xFF3F51B5) : Colors.grey.shade400,
            child: Text(
              '$stepNumber',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              instruction,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isActive ? Colors.black87 : Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
