import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/constants/text.dart';
import 'package:futureme/feature/video_welcome_screen.dart';
class OnboardingScreen extends StatelessWidget{
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xFFFEF6F2),
      body: SingleChildScrollView(
        scrollDirection:Axis.vertical,
        padding: EdgeInsets.all(0),
        child:  Container(
          padding: EdgeInsets.all(0),
        child:Column(
          children: [
            Image.asset(AssetData.onboardingImage),
            SvgPicture.asset(
              AssetData.splashImage
            ),
            SizedBox(
              height:20
            ),
            TextData.pageName("Aici ești \nîn siguranță"),  
             SizedBox(
              height:20
            ),
              TextData.centerText("FutureMe te ghidează pas cu pas să te înțelegi mai bine și să îți clarifici direcția, fără presiune și fără răspunsuri perfecte.",),
              SizedBox(
              height:20
            ),
             TextData.customButton(content: "Încep în ritmul meu",
             onpressed: (){
              Navigator.push(context,MaterialPageRoute(builder: (context) => VideoWelcome()));
             }
             ),
             
              SizedBox(height:15,),
              TextData.tagText("Am deja cont"),
              SizedBox(height:20)
            
          ],
      )

      )   
       )

      ) ; }
}