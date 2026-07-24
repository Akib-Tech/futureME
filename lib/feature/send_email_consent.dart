import 'package:flutter/material.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/feature/confirm_consent_info.dart';
import 'package:futureme/shared/widgets/center_text.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/page_title.dart';
import 'package:futureme/shared/widgets/primary_button.dart';
import 'package:futureme/shared/widgets/tag_button.dart';


class SendEmailConsent extends StatefulWidget{
  const SendEmailConsent({super.key});

  @override
  State<SendEmailConsent> createState() => SendEmailConsentState();
}

class SendEmailConsentState extends State<SendEmailConsent>{


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
              PageTitle(content: "Așteptăm acordul"),
              SizedBox(height:50),
              CenterText(content: "Am trimis linkul către părintele sau tutorele tău. După confirmare, vei putea continua \n în FutureMe."),

              SizedBox(height: 300,),
              PrimaryButton(content: "Verifică acordul", onpressed: (){
                goToNextPage(ConfirmConsent());
              }),
              SizedBox(height: 5,),
               TagButton(content: "Schimbă adresa de email")
            ]
          )

          )
        );
    }
}
