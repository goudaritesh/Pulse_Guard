import 'package:flutter/material.dart';
import 'dart:async'; // For StreamSubscription and Timer
import 'package:sensors_plus/sensors_plus.dart'; // For accelerometer data
import 'package:video_player/video_player.dart'; // For video playback
import 'package:chewie/chewie.dart'; // For video player UI controls
import 'package:fl_chart/fl_chart.dart'; // For charting (though not used in this no-backend version's progress)

class SensorService {
  StreamSubscription? _accelerometerSubscription;
  StreamSubscription? _gyroscopeSubscription;
  final _accelerometerController = StreamController<AccelerometerEvent>.broadcast();
  final _gyroscopeController = StreamController<GyroscopeEvent>.broadcast();

  Stream<AccelerometerEvent> get accelerometerStream => _accelerometerController.stream;
  Stream<GyroscopeEvent> get gyroscopeStream => _gyroscopeController.stream;

  void startListening() {
    // Set sensor update interval (e.g., UI updates at 60Hz)
    // SensorInterval.uiInterval is a good default for UI-related updates
    _accelerometerSubscription = accelerometerEvents.listen(
          (AccelerometerEvent event) {
        if (!_accelerometerController.isClosed) {
          _accelerometerController.add(event);
        }
      },
      onError: (error) {
        // ignore: avoid_print
        print('Error reading accelerometer: $error');
        if (!_accelerometerController.isClosed) {
          _accelerometerController.addError(error);
        }
      },
      cancelOnError: true,
    );

    _gyroscopeSubscription = gyroscopeEvents.listen(
          (GyroscopeEvent event) {
        if (!_gyroscopeController.isClosed) {
          _gyroscopeController.add(event);
        }
      },
      onError: (error) {
        // ignore: avoid_print
        print('Error reading gyroscope: $error');
        if (!_gyroscopeController.isClosed) {
          _gyroscopeController.addError(error);
        }
      },
      cancelOnError: true,
    );
  }

  void stopListening() {
    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;
    _gyroscopeSubscription?.cancel();
    _gyroscopeSubscription = null;
  }

  void dispose() {
    _accelerometerController.close();
    _gyroscopeController.close();
    stopListening();
  }
}