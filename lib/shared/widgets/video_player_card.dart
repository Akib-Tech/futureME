import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerCard extends StatelessWidget {
  const VideoPlayerCard(this.controller, {super.key});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 1,
                color: Color(0xFFE9DCD7),
              ),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: VideoPlayer(controller),
                )
              : const SizedBox(
                  child: CircularProgressIndicator(),
                ),
        ),
        Positioned(
          top: 60,
          left: 140,
          child: FloatingActionButton(
            onPressed: () {
              controller.value.isPlaying ? controller.pause() : controller.play();
            },
            child: Icon(controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
          ),
        ),
      ],
    );
  }
}
