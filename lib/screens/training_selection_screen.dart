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
import 'calibration_screen.dart'; // For charting (though not used in this no-backend version's progress)

class TrainingSelectionScreen extends StatefulWidget {
  const TrainingSelectionScreen({super.key}); // Use super.key

  @override
  State<TrainingSelectionScreen> createState() => _TrainingSelectionScreenState();
}

class _TrainingSelectionScreenState extends State<TrainingSelectionScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Gender and Age Category selections
  String _selectedGender = 'Male';
  String _selectedAgeCategory = 'Adult (18-45 yrs)';

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _ageCategories = ['Child (1-17 yrs)', 'Adult (18-45 yrs)', 'Seniors (46+ yrs)'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart CPR Training', style: Theme.of(context).textTheme.headlineSmall),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF3F51B5), // Selected tab color
          unselectedLabelColor: Colors.grey, // Unselected tab color
          indicatorColor: const Color(0xFF3F51B5),
          tabs: const [
            Tab(text: 'Training'),
            Tab(text: 'Progress'), // Placeholder without backend
            Tab(text: 'Leaderboard'), // Placeholder without backend
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Training Tab Content
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Patient Profile:',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 15),
                // Gender Dropdown
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedGender,
                      icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF3F51B5)),
                      style: Theme.of(context).textTheme.bodyLarge,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedGender = newValue!;
                        });
                      },
                      items: _genders.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Age Category Dropdown
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedAgeCategory,
                      icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF3F51B5)),
                      style: Theme.of(context).textTheme.bodyLarge,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedAgeCategory = newValue!;
                        });
                      },
                      items: _ageCategories.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'Select Training Module:',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 15),
                _buildTrainingCard(
                  context,
                  'Adult CPR',
                  'Standard adult CPR with compression feedback',
                  'Beginner',
                  '15 min',
                  Icons.person,
                  const [Color(0xFF6A1B9A), Color(0xFF4A148C)], // Purple gradient
                      () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CalibrationScreen(
                        cprType: 'Adult CPR',
                        patientProfile: PatientProfile(gender: _selectedGender, ageCategory: _selectedAgeCategory),
                      ),
                    ),
                  ),
                ),
                _buildTrainingCard(
                  context,
                  'Child CPR',
                  'Modified CPR technique for children',
                  'Intermediate',
                  '12 min',
                  Icons.child_care,
                  const [Color(0xFF42A5F5), Color(0xFF1976D2)], // Blue gradient
                      () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CalibrationScreen(
                        cprType: 'Child CPR',
                        patientProfile: PatientProfile(gender: _selectedGender, ageCategory: _selectedAgeCategory),
                      ),
                    ),
                  ),
                ),
                _buildTrainingCard(
                  context,
                  'Rhythm Challenge',
                  'Focus on maintaining optimal compression rate',
                  'Advanced',
                  '10 min',
                  Icons.music_note,
                  const [Color(0xFFFFEE58), Color(0xFFFDD835)], // Yellow gradient
                      () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CalibrationScreen(
                        cprType: 'Rhythm Challenge',
                        patientProfile: PatientProfile(gender: _selectedGender, ageCategory: _selectedAgeCategory),
                      ),
                    ),
                  ),
                ),
                // Add more training modules here
              ],
            ),
          ),
          // Progress Tab Content (Placeholder)
          Center(
            child: Text(
              'Under Process',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.grey),
            ),
          ),
          // Leaderboard Tab Content (Placeholder)
          Center(
            child: Text(
              'Leaderboard rankings would be displayed here.\n(Requires backend for persistence)',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingCard(
      BuildContext context,
      String title,
      String description,
      String difficulty,
      String duration,
      IconData icon,
      List<Color> colors,
      VoidCallback onTap,
      ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 30, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  _buildInfoChip(context, difficulty),
                  const SizedBox(width: 10),
                  _buildInfoChip(context, duration),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}