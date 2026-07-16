import 'package:flutter/material.dart';
import 'package:futureme/core/constants/text.dart';
import 'package:video_player/video_player.dart';

class AssetData{
  static const splashImage = "assets/images/splash.svg";
  static const onboardingImage = "assets/images/background.png";
  static const fullOnboardingImage = "assets/images/videoHeaderBackground.png";
  static const sunnyDay = "assets/images/sunnyDay.png";
  static const loveIcon = "assets/images/heartIcon.png";
  static const appleIcon = "assets/images/appleIcon.png";
  static const googleIcon = "assets/images/googleIcon.png";
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
        SizedBox(
          child: CircularProgressIndicator(),
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

  static Widget divider(){
    return Container(
    width: 345,
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 16,
        children: [
            Expanded(
                child: Container(
                    decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: 1,
                                strokeAlign: BorderSide.strokeAlignCenter,
                                color: const Color(0xFFE9DCD7) /* ui-border-default */,
                            ),
                        ),
                    ),
                ),
            ),
            Container(
                width: 16,
                height: 16,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(),
                child: Stack(
                  children: [
                   Image.asset(loveIcon)
                  ],
                ),
            ),
            Expanded(
                child: Container(
                    decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: 1,
                                strokeAlign: BorderSide.strokeAlignCenter,
                                color: const Color(0xFFE9DCD7) /* ui-border-default */,
                            ),
                        ),
                    ),
                ),
            ),
        ],
    ),
);
  }

 static Widget textForm(){
return TextFormField(
 decoration: InputDecoration(
   filled: true,
   fillColor: Colors.white,
   border: OutlineInputBorder(
     borderSide: BorderSide.none,
     borderRadius: BorderRadius.circular(50),
   ),
   hintText: 'Enter your name',
   hintStyle: TextStyle(color:Color(0xFF8B7D92)),
 ),
 style: TextStyle(color: Colors.white),
 cursorColor: Colors.black,
);
 
 }
  }