import 'package:flutter/material.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:video_player/video_player.dart';

class VideoApp extends StatefulWidget{
     const VideoApp({super.key});

    @override
    State<VideoApp> createState() => _VideoAppState();

}

class _VideoAppState extends State<VideoApp>{
    late VideoPlayerController _controller;
    @override
    void initState(){
      super.initState();
      _controller = VideoPlayerController.networkUrl(
        Uri.parse('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
          viewType:VideoViewType.platformView,
          videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: true)          
           );
           _controller.initialize().then((_) => {
              setState((){})
           });
    }

 @override

  @override
  Widget build(BuildContext context){
      return AssetData.videoPlayer(_controller);
   
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

}

