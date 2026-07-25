import 'package:flutter/material.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/feature/consent/send_email_consent.dart';
import 'package:futureme/shared/widgets/app_text_field.dart';
import 'package:futureme/shared/widgets/center_text.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/left_bold_text.dart';
import 'package:futureme/shared/widgets/left_light_text.dart';
import 'package:futureme/shared/widgets/page_title.dart';
import 'package:futureme/shared/widgets/primary_button.dart';
import 'package:futureme/shared/widgets/rounded_card.dart';
import 'package:futureme/shared/widgets/tag_button.dart';

class EmailConsent extends StatefulWidget{
  const EmailConsent({super.key});

  @override
  State<EmailConsent> createState() => EmailConsentState();
}

class EmailConsentState extends State<EmailConsent>{


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
            padding: EdgeInsets.all(20),
            child:  Column(
            children:[

              CustomAppBar(context),
              SizedBox(height:20),
                Image.asset(AppAssets.sunnyDay),
                SizedBox(height:30),
              PageTitle(content:"Trimitem cererea pentru acord"),
              SizedBox(height:20),
              CenterText(content: "Introdu adresa de email a unui părinte sau tutore. Îi vom trimite un link unde poate citi informțiile despre FutureMe și își poate da acordul."),

              SizedBox(height: 30,),
              LeftBoldText(content: "Email părinte/tutore"),
              SizedBox(height: 10,),
              RoundedCard(
                contents: [
                  AppTextField(hintText: "exemplu@email.com")
                ]
              ),
              SizedBox(height: 5,),
              LeftLightText(content: "Nu vom trimite materiale promoționale pe această adresă."),
              SizedBox(height: 80,),
              PrimaryButton(content: "Trimite cererea", onpressed: (){
                goToNextPage(SendEmailConsent());
              }),
              SizedBox(height: 5,),
               TagButton(content: "Revin mai târziu", onTap: () => Navigator.pop(context))
            ]
          )

          )
        );
    }
}
