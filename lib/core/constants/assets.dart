import 'package:flutter/material.dart';
import 'package:futureme/core/constants/text.dart';
import 'package:video_player/video_player.dart';

class AssetData{
  static const splashImage = "assets/images/splash.svg";
  static const onboardingImage = "assets/images/background.png";
  static const fullOnboardingImage = "assets/images/videoHeaderBackground.png";
  static const sunnyDay = "assets/images/sunnyDay.png";

  static Widget videoPlayer (VideoPlayerController controller){
      return Stack(
            children: [
                Container(
                  decoration:ShapeDecoration(
                  color: Colors.white ,
                  shape:RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
color: const Color(0xFFE9DCD7) 
                    ),
                    borderRadius: BorderRadius.circular(30)
                  ),
                  ),
        child: controller.value.isInitialized
           ? 
        AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: VideoPlayer(controller)
        )
           :
        Container(
            )
      ),
      Positioned(
        top:60,
        left:140,
        child:       
      FloatingActionButton(
          onPressed: () {
              controller.value.isPlaying ? controller.pause() : controller.play();
          },
         child: Icon(controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
        ),
        )
            ],
          );
  }

  static Widget customAppBar(context){
    return AppBar(
      backgroundColor: Color(TextData.backgroundColor),
      leading: GestureDetector(
        onTap: (){
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back_ios)
      ),
      
    );
  }
  }