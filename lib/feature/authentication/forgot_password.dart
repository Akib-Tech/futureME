import 'package:flutter/material.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/feature/starterInfo/function_video.dart';
import 'package:futureme/shared/widgets/center_text.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/left_light_text.dart';
import 'package:futureme/shared/widgets/page_title.dart';
import 'package:futureme/shared/widgets/primary_button.dart';
import 'package:futureme/shared/widgets/rounded_card.dart';
import 'package:futureme/shared/widgets/app_text_field.dart';
import 'package:futureme/shared/widgets/left_bold_text.dart';



class ForgotPassword extends StatefulWidget{
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword>{


    void goToNextPage(Widget? nextPage){
      Navigator.push(context,MaterialPageRoute(builder: (context) => nextPage! ));
    }

    @override
    void initState(){
      super.initState();
    }

    @override
    Widget build(BuildContext context){
        return Scaffold(
          backgroundColor : AppColors.background,
          body: SingleChildScrollView(
            child: Container(
            padding: EdgeInsets.all(30),
            child:  Column(
            children:[
              CustomAppBar(context),
               SizedBox(height:30),
              PageTitle(content:"Hai să ne cunoaștem"),
              SizedBox(height:20),
              CenterText(content: "Spune-ne prenumele tău, ca fiecare pas să se simtă puțin mai aproape de tine"),
              SizedBox(height:20),
               LeftBoldText(content: "Prenume"),
               SizedBox(height:10),
               RoundedCard(contents: [
                AppTextField(),
              ]),
              SizedBox(height:10),
               LeftLightText(content:"Îl poți schimba oricând din contul tău."),
              SizedBox(height:350),
              PrimaryButton(content: "Continua", onpressed: (){
                goToNextPage(FunctionVideo());
              }),

            ]
          )

          ),
          )
        );
    }
}
