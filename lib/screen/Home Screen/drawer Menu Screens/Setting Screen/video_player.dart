import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String title;
  final bool
  isAsset; // Set to true if playing from local assets, false for internet URLs

  const VideoPlayerScreen({
    super.key,
    required this.videoUrl,
    required this.title,
    this.isAsset = false,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      // 1. Initialize the Video Source (Asset vs Network)
      _videoPlayerController = widget.isAsset
          ? VideoPlayerController.asset(widget.videoUrl)
          : VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));

      await _videoPlayerController.initialize();

      // 2. Configure the Chewie UI Player
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true, // Automatically start playing
        looping: false,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        // Spiritual / Premium UI Styling
        materialProgressColors: ChewieProgressColors(
          playedColor: Theme.of(context).colorScheme.primary,
          handleColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Colors.grey.shade800,
          bufferedColor: Colors.grey.shade600,
        ),
        placeholder: Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
        autoInitialize: true,
      );

      setState(() {});
    } catch (e) {
      setState(() {
        _hasError = true;
      });
      debugPrint("Video Player Error: $e");
    }
  }

  @override
  void dispose() {
    // ALWAYS dispose controllers to prevent memory leaks!
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    // Force portrait mode when exiting fullscreen video
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black, // Dark background is best for videos
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: _hasError
              ? _buildErrorState(theme)
              : _chewieController != null &&
                    _chewieController!.videoPlayerController.value.isInitialized
              ? Chewie(controller: _chewieController!)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: theme.colorScheme.primary),
                    const SizedBox(height: 20),
                    const Text(
                      "Loading Divine Darshan...",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline_rounded,
          color: theme.colorScheme.error,
          size: 50,
        ),
        const SizedBox(height: 16),
        const Text(
          "Could not load the video.",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          "Please check your internet connection.",
          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13),
        ),
      ],
    );
  }
}
