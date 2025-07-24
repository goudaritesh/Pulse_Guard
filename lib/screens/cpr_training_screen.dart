import 'package:cpr_training_app/screens/session_summary_screen.dart';
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
import '../widgets/gradient_button.dart';
import '../widgets/sensor_line_chart.dart'; // For charting (though not used in this no-backend version's progress)

class CprTrainingScreen extends StatefulWidget {
  final String cprType;
  final PatientProfile patientProfile; // Receive patient profile

  const CprTrainingScreen({super.key, required this.cprType, required this.patientProfile}); // Use super.key

  @override
  _CprTrainingScreenState createState() => _CprTrainingScreenState();
}

class _CprTrainingScreenState extends State<CprTrainingScreen> {
  final SensorService _sensorService = SensorService();
  late CprAnalyzer _cprAnalyzer;
  StreamSubscription? _cprDataSubscription;
  Timer? _sessionTimer;
  int _elapsedSeconds = 0;
  bool _isTraining = false;

  // Real-time display values
  double _currentRate = 0.0;
  double _currentDepthScore = 0.0; // 0.0 to 1.0
  String _currentFeedback = "Start compressions...";

  // Session aggregate values for summary (these will not be persisted without a backend)
  List<double> _rateHistory = [];
  List<double> _depthScoreHistory = [];

  // Placeholder video URL for CPR training demonstration.
  // Replace with your actual animated CPR training video URL.
  final String _cprDemoVideoUrl = 'assets/videos/cprdemo.mp4';


  @override
  void initState() {
    super.initState();
    // Initialize CprAnalyzer with the patient profile
    _cprAnalyzer = CprAnalyzer(patientProfile: widget.patientProfile, cprType: widget.cprType);
    // Start listening to sensors immediately on this screen for graphs
    _sensorService.startListening();
  }

  @override
  void dispose() {
    _stopTraining(); // Ensure subscriptions are cancelled
    _cprAnalyzer.dispose();
    _sensorService.stopListening(); // Stop sensor listening
    super.dispose();
  }

  void _startTraining() {
    setState(() {
      _isTraining = true;
      _elapsedSeconds = 0;
      _currentRate = 0.0;
      _currentDepthScore = 0.0;
      _currentFeedback = "Start compressions...";
      _rateHistory.clear();
      _depthScoreHistory.clear();
    });

    _cprAnalyzer.startAnalysis(_sensorService.accelerometerStream); // Start CPR analysis

    _cprDataSubscription = _cprAnalyzer.cprDataStream.listen((data) {
      setState(() {
        _currentRate = data['rate'] as double;
        _currentDepthScore = data['simulatedDepthScore'] as double;
        _currentFeedback = data['feedback'] as String;

        if (_currentRate > 0) { // Only record if actual compressions are happening
          _rateHistory.add(_currentRate);
        }
        _depthScoreHistory.add(_currentDepthScore);
      });
    });

    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  void _stopTraining() async {
    if (!_isTraining) return;

    setState(() {
      _isTraining = false;
    });

    _cprAnalyzer.stopAnalysis();
    _cprDataSubscription?.cancel();
    _sessionTimer?.cancel();

    // Calculate session summary (will not be saved anywhere)
    double averageRate = _rateHistory.isNotEmpty
        ? _rateHistory.reduce((a, b) => a + b) / _rateHistory.length
        : 0.0;
    double averageDepthScore = _depthScoreHistory.isNotEmpty
        ? _depthScoreHistory.reduce((a, b) => a + b) / _depthScoreHistory.length
        : 0.0;

    // A simple overall score calculation
    double overallScore = (_cprAnalyzer.isRateOptimal(averageRate) ? 0.5 : 0.0) +
        (averageDepthScore * 0.5); // Depth score contributes 50%
    overallScore = (overallScore * 100).clamp(0, 100); // Convert to percentage

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SessionSummaryScreen(
          averageRate: averageRate,
          averageDepthScore: averageDepthScore,
          overallScore: overallScore,
          durationSeconds: _elapsedSeconds,
          patientProfile: widget.patientProfile, // Pass patient profile to summary
        ),
      ),
    );
  }

  void _showCprInstructionVideo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                title: const Text('CPR Instructions Video'),
                backgroundColor: Theme.of(context).primaryColor,
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: VideoPlayerWidget(
                  videoUrl: _cprDemoVideoUrl,
                  autoPlay: true, // Autoplay when shown in modal
                  looping: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Watch this video to understand the correct CPR technique.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.cprType} Training', style: Theme.of(context).textTheme.headlineSmall),
        actions: [
          IconButton(
            icon: const Icon(Icons.ondemand_video, color: Color(0xFF3F51B5)),
            tooltip: 'Watch Instructions',
            onPressed: _showCprInstructionVideo,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Session: ${_formatDuration(_elapsedSeconds)} / 15:00', // Hardcoded 15 min for demo
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            // Heart icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFBBDEFB), Color(0xFF90CAF9)], // Light blue gradient
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade200.withOpacity(0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.favorite,
                  color: Colors.pinkAccent,
                  size: 60,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            _currentRate.toStringAsFixed(0),
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: _cprAnalyzer.isRateOptimal(_currentRate) ? Colors.green.shade600 : Colors.red.shade600,
                            ),
                          ),
                          Text(
                            'RATE (CPM)',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            (_cprAnalyzer.getDepthInCm(_currentDepthScore)).toStringAsFixed(1), // Scaled depth
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: _currentDepthScore >= _cprAnalyzer.optimalDepthScoreThreshold ? Colors.green.shade600 : Colors.red.shade600,
                            ),
                          ),
                          Text(
                            'DEPTH (CM)',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      _currentFeedback.contains('Good') || _currentFeedback.contains('Excellent')
                          ? Icons.check_circle_outline
                          : Icons.error_outline,
                      color: _currentFeedback.contains('Good') || _currentFeedback.contains('Excellent')
                          ? Colors.green.shade600
                          : Colors.red.shade600,
                      size: 40,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _currentFeedback,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: _currentFeedback.contains('Good') || _currentFeedback.contains('Excellent')
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Sensor Line Charts
            SensorLineChart(
              sensorDataStream: _sensorService.accelerometerStream.map((e) => [e.x, e.y, e.z]),
              title: 'Accelerometer Data (m/s²)',
              minY: -30, // Adjust min/max based on expected sensor range
              maxY: 30,
            ),
            const SizedBox(height: 20),
            SensorLineChart(
              sensorDataStream: _sensorService.gyroscopeStream.map((e) => [e.x, e.y, e.z]),
              title: 'Gyroscope Data (rad/s)',
              minY: -5, // Adjust min/max based on expected sensor range
              maxY: 5,
            ),
            const SizedBox(height: 30),
            _isTraining
                ? GradientButton(
              text: 'Pause Session',
              onPressed: _stopTraining, // Using stop for now, can be pause/resume logic
              colors: const [Colors.orange, Colors.deepOrange],
              icon: Icons.pause,
            )
                : GradientButton(
              text: 'Start Session',
              onPressed: _startTraining,
              colors: const [Colors.green, Colors.lightGreen],
              icon: Icons.play_arrow,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}