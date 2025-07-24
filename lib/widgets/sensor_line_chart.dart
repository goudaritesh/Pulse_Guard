import 'package:flutter/material.dart';
import 'dart:async'; // For StreamSubscription and Timer
import 'package:sensors_plus/sensors_plus.dart'; // For accelerometer data
import 'package:video_player/video_player.dart'; // For video playback
import 'package:chewie/chewie.dart'; // For video player UI controls
import 'package:fl_chart/fl_chart.dart'; // For charting (though not used in this no-backend version's progress)
class SensorLineChart extends StatefulWidget {
  final Stream<List<double>> sensorDataStream; // Stream of [x, y, z] values
  final String title;
  final double minY;
  final double maxY;
  final int maxDataPoints; // Max points to display on the chart

  const SensorLineChart({
    super.key, // Use super.key
    required this.sensorDataStream,
    required this.title,
    this.minY = -20, // Default range for accelerometer/gyroscope
    this.maxY = 20,
    this.maxDataPoints = 60, // Display last 60 data points (e.g., 1 second at 60Hz)
  });

  @override
  State<SensorLineChart> createState() => _SensorLineChartState();
}

class _SensorLineChartState extends State<SensorLineChart> {
  final List<FlSpot> _xSpots = [];
  final List<FlSpot> _ySpots = [];
  final List<FlSpot> _zSpots = [];
  StreamSubscription? _dataSubscription;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _dataSubscription = widget.sensorDataStream.listen((data) {
      if (mounted) {
        setState(() {
          _xSpots.add(FlSpot(_currentIndex.toDouble(), data[0]));
          _ySpots.add(FlSpot(_currentIndex.toDouble(), data[1]));
          _zSpots.add(FlSpot(_currentIndex.toDouble(), data[2]));

          if (_xSpots.length > widget.maxDataPoints) {
            _xSpots.removeAt(0);
            _ySpots.removeAt(0);
            _zSpots.removeAt(0);
            // Shift all x values back to keep chart aligned
            for (int i = 0; i < _xSpots.length; i++) {
              _xSpots[i] = FlSpot(_xSpots[i].x - 1, _xSpots[i].y);
              _ySpots[i] = FlSpot(_ySpots[i].x - 1, _ySpots[i].y);
              _zSpots[i] = FlSpot(_zSpots[i].x - 1, _zSpots[i].y);
            }
          } else {
            _currentIndex++;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _dataSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 150, // Fixed height for the chart
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    drawHorizontalLine: true,
                    getDrawingHorizontalLine: (value) {
                      return const FlLine(
                        color: Colors.black12,
                        strokeWidth: 0.5,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false, // Hide bottom labels for continuous stream
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: (widget.maxY - widget.minY) / 4, // Show 4 intervals
                        getTitlesWidget: (value, meta) {
                          return Text(value.toStringAsFixed(0), style: const TextStyle(fontSize: 10));
                        },
                        reservedSize: 30,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.black12, width: 1),
                  ),
                  minX: _xSpots.isNotEmpty ? _xSpots.first.x : 0,
                  maxX: _xSpots.isNotEmpty ? _xSpots.last.x : widget.maxDataPoints.toDouble(),
                  minY: widget.minY,
                  maxY: widget.maxY,
                  lineBarsData: [
                    LineChartBarData(
                      spots: _xSpots,
                      isCurved: true,
                      color: Colors.redAccent,
                      barWidth: 2,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                    LineChartBarData(
                      spots: _ySpots,
                      isCurved: true,
                      color: Colors.greenAccent,
                      barWidth: 2,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                    LineChartBarData(
                      spots: _zSpots,
                      isCurved: true,
                      color: Colors.blueAccent,
                      barWidth: 2,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAxisLegend('X', Colors.redAccent),
                _buildAxisLegend('Y', Colors.greenAccent),
                _buildAxisLegend('Z', Colors.blueAccent),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAxisLegend(String axis, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(axis, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
