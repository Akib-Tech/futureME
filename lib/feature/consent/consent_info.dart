import 'package:flutter/material.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/feature/consent/email_consent.dart';
import 'package:futureme/shared/widgets/center_text.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/icon_divider.dart';
import 'package:futureme/shared/widgets/page_title.dart';
import 'package:futureme/shared/widgets/primary_button.dart';
import 'package:futureme/shared/widgets/tag_button.dart';


class ConsentInfo extends StatefulWidget{
  const ConsentInfo({super.key});

  @override
  State<ConsentInfo> createState() => ConsentInfoState();
}

class ConsentInfoState extends State<ConsentInfo>{


    void goToNextPage(Widget nextPage){
      Navigator.push(context,MaterialPageRoute(builder: (context) => nextPage ));
    }

    @override
    void initState(){
      super.initState();
    }

    @override
    Widget build(BuildContext context){
        return Scaffold(
          backgroundColor : AppColors.background,
          body: Container(
            padding: EdgeInsets.all(30),
            child:  Column(
            children:[

              CustomAppBar(context),
              SizedBox(height:50),
                Image.asset(AppAssets.sunnyDay),
                SizedBox(height:30),
              PageTitle(content: "Avem nevoie de acordul unui părinte"),
              SizedBox(height:20),
              CenterText(content: "Pentru vârsta ta, este nevoie ca un părinte sau tutore legal să își dea acordul înainte să continui evaluarea."),
              SizedBox(height:20),
              IconDivider(),
              SizedBox(height:20),
              CenterText(content: "După acest pas, vei putea merge mai departe în ritmul tău."),
              SizedBox(height: 70,),
              PrimaryButton(content: "Continuă cu acordul", onpressed: (){
                goToNextPage(EmailConsent());
              }),
              SizedBox(height: 20,),
               TagButton(content: "Revin mai târziu", onTap: () => Navigator.pop(context))
            ]
          )

          )
        );
    }
}
