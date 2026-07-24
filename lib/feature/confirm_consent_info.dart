import 'package:flutter/material.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/feature/authentication/login.dart';
import 'package:futureme/shared/widgets/center_text.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/icon_divider.dart';
import 'package:futureme/shared/widgets/page_title.dart';
import 'package:futureme/shared/widgets/primary_button.dart';


class ConfirmConsent extends StatefulWidget{
  const ConfirmConsent({super.key});

  @override
  State<ConfirmConsent> createState() => ConfirmConsentState();
}

class ConfirmConsentState extends State<ConfirmConsent>{


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
              PageTitle(content: "Acordul a fost \n confirmat"),
              SizedBox(height:20),
              CenterText(content: "Mulțumim! Acum poți continua experiența FutureMe."),
              SizedBox(height:20),
              IconDivider(),
              SizedBox(height:20),
              CenterText(content: "Răspunsurile tale sunt în siguranță. Le folosim pentru a personaliza pașii, interpretările și raportul tău final. Poți merge mai departe în ritmul tău."),
              SizedBox(height: 180,),
              PrimaryButton(content: "Continuă ", onpressed: (){
                goToNextPage(LoginPage());
              }),
            ]
          )

          )
        );
    }
}
