import 'package:flutter/material.dart';
import 'dart:async'; // For StreamSubscription and Timer
import 'package:sensors_plus/sensors_plus.dart'; // For accelerometer data
import 'package:video_player/video_player.dart'; // For video playback
import 'package:chewie/chewie.dart'; // For video player UI controls
import 'package:fl_chart/fl_chart.dart'; // For charting (though not used in this no-backend version's progress)

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final bool autoPlay;
  final bool looping;
  final double aspectRatio;

  const VideoPlayerWidget({
    super.key, // Use super.key
    required this.videoUrl,
    this.autoPlay = false,
    this.looping = false,
    this.aspectRatio = 16 / 9, // Default aspect ratio
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    // Determine if it's a network URL or an asset path
    if (widget.videoUrl.startsWith('http://') || widget.videoUrl.startsWith('https://')) {
      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    } else {
      _videoPlayerController = VideoPlayerController.asset(widget.videoUrl);
    }

    await _videoPlayerController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: widget.autoPlay,
      looping: widget.looping,
      aspectRatio: widget.aspectRatio,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            'Error playing video: $errorMessage',
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
      // Hide all controls for the intro video on WelcomeScreen, show for others
      showControls: !widget.autoPlay || widget.looping,
      // You can customize controls further here if needed
    );

    setState(() {}); // Rebuild to show the Chewie player
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
        ? AspectRatio(
      aspectRatio: _chewieController!.aspectRatio ?? widget.aspectRatio,
      child: Chewie(
        controller: _chewieController!,
      ),
    )
        : const Center(
      child: CircularProgressIndicator(),
    );
  }
}