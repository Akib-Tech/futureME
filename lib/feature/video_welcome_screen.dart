import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/feature/age_set_screen.dart';
import 'package:futureme/shared/widgets/center_text.dart';
import 'package:futureme/shared/widgets/page_title.dart';
import 'package:futureme/shared/widgets/primary_button.dart';
import 'package:futureme/shared/widgets/video_lesson_card.dart';

class VideoWelcome extends StatefulWidget{
    const VideoWelcome({super.key});

    @override
    State<VideoWelcome> createState() => VideoWelcomeState();
}

class VideoWelcomeState extends State<VideoWelcome>{


@override
Widget build(BuildContext context){
  return Scaffold(
    backgroundColor: AppColors.background,
    body: SingleChildScrollView(
    padding: EdgeInsets.all(0),
    scrollDirection:Axis.vertical,
    child: Container(
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
            color: AppColors.background
        ),
      child:  Column(
        children: [
      Image.asset(
      AppAssets.fullOnboardingImage,
      fit:BoxFit.contain,

      ),
            SvgPicture.asset(
              AppAssets.splashImage
            ),
SizedBox(height: 20),
          Container(
            padding:EdgeInsets.symmetric(horizontal: 20,vertical: 0),
            child: Column(children: [
                          PageTitle(content: "Înainte să începem"),
             SizedBox(height: 20),
          CenterText(content: "Am pregătit un mesaj scurt pentru tine,\n ca să știi cum vom merge mai departe:\n pas cu pas, fără presiune."),
            SizedBox(height: 20),
          VideoLessonCard(title: "Mesaj de bun venit"),
            SizedBox(height: 100),
           PrimaryButton(content:"Continuation",onpressed: (){
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
