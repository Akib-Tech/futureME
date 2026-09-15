import 'package:flutter/material.dart';
import 'package:futureme/shared/widgets/video_player_card.dart';
import 'package:video_player/video_player.dart';

class VideoApp extends StatefulWidget {
  const VideoApp({super.key});

  @override
  State<VideoApp> createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> with WidgetsBindingObserver {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = VideoPlayerController.asset(
      'assets/videos/intro.mp4',
      viewType: VideoViewType.platformView,
      videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: false),
    );
    _controller.initialize().then((_) => setState(() {}));
  }

  /// Navigating forward pushes the next screen on top rather than replacing
  /// this one, so dispose never runs and the narration kept playing over the
  /// pages that followed. Pausing when the app or route stops being visible
  /// stops the audio whichever way the user leaves.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      _controller.pause();
    }
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return VideoPlayerCard(_controller);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }
}