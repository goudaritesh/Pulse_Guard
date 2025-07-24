import 'package:cpr_training_app/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async'; // For StreamSubscription and Timer
import 'package:sensors_plus/sensors_plus.dart'; // For accelerometer and gyroscope data
import 'package:video_player/video_player.dart'; // For video playback
import 'package:chewie/chewie.dart'; // For video player UI controls
import 'package:fl_chart/fl_chart.dart'; // For displaying line charts

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Use super.key

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PulseGuard CPR Trainer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Inter', // Using Inter font as per instructions
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent, // Transparent app bar
          elevation: 0, // No shadow
          foregroundColor: Color(0xFF3F51B5), // Dark blue text for app bar
          centerTitle: true,
        ),
        scaffoldBackgroundColor: Colors.white, // White background
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            elevation: 5, // Add some shadow
          ),
        ),
        cardTheme: CardThemeData( // Corrected to CardThemeData
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // More rounded corners
          ),
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Color(0xFF3F51B5)), // Dark blue for titles
          headlineMedium: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold, color: Color(0xFF3F51B5)),
          headlineSmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Color(0xFF3F51B5)),
          titleLarge: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Color(0xFF3F51B5)),
          titleMedium: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Color(0xFF3F51B5)),
          titleSmall: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xFF3F51B5)),
          bodyLarge: TextStyle(fontSize: 16.0, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 14.0, color: Colors.black54),
          labelLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      home: const WelcomeScreen(), // Start with the new WelcomeScreen
    );
  }
}