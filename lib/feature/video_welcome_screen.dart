import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/constants/text.dart';
import 'package:futureme/feature/age_set_screen.dart';
import 'package:futureme/shared/video_player_screen.dart';

class VideoWelcome extends StatefulWidget{
    const VideoWelcome({super.key});

    @override
    State<VideoWelcome> createState() => VideoWelcomeState();
}

class VideoWelcomeState extends State<VideoWelcome>{
  
 
@override
Widget build(BuildContext context){
  return Scaffold(
    backgroundColor: Color(0xFFFEF6F2),
    body: SingleChildScrollView(
    padding: EdgeInsets.all(0),
    scrollDirection:Axis.vertical,
    child: Container(
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
            color: const Color(0xFFFEF6F2)
        ),
      child:  Column(
        children: [
      Image.asset(
      AssetData.fullOnboardingImage,
      fit:BoxFit.contain,

      ),
            SvgPicture.asset(
              AssetData.splashImage
            ),
SizedBox(height: 20),
          Container(
            padding:EdgeInsets.symmetric(horizontal: 20,vertical: 0),
            child: Column(children: [
                          TextData.pageName(content: "Înainte să începem"),
             SizedBox(height: 20),
          TextData.centerText(content: "Am pregătit un mesaj scurt pentru tine,\n ca să știi cum vom merge mai departe:\n pas cu pas, fără presiune."),
            SizedBox(height: 20),
          TextData.roundedContainer([
            VideoApp(),
            SizedBox(
              height: 10,
            ),
            TextData.leftBoldText(content: "Mesaj de bun venit"),
            SizedBox(
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.timelapse_rounded,
                color: Color(0xFF6D5D78),
                ),
                Expanded(
                  child:TextData.leftLightText(content: "1 Min"),
                )
                
              ],
            ),
            ),
          
           
            ],),
            SizedBox(height: 100),
           TextData.customButton(content:"Continuation",onpressed: (){ 
            Navigator.push(context,MaterialPageRoute(builder: (context) => AgeSet() ));
            }),
         ] )
          )
    ],)
    )
  )

  );
  }

}