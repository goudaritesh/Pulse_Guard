import 'package:flutter/material.dart';
import 'dart:async'; // For StreamSubscription and Timer
import 'package:sensors_plus/sensors_plus.dart'; // For accelerometer and gyroscope data
import 'package:video_player/video_player.dart'; // For video playback
import 'package:chewie/chewie.dart'; // For video player UI controls
import 'package:fl_chart/fl_chart.dart'; // For displaying line charts

class PatientProfile {
  final String gender; // e.g., 'Male', 'Female', 'Other'
  final String ageCategory; // e.g., 'Adult', 'Child', 'Seniors'

  PatientProfile({required this.gender, required this.ageCategory});
}
