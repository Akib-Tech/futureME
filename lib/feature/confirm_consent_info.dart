import 'package:flutter/material.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/constants/text.dart';
import 'package:futureme/feature/authentication/login.dart';


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
          backgroundColor : Color(TextData.backgroundColor),
          body: Container(
            padding: EdgeInsets.all(30),
            child:  Column(
            children:[
            
              AssetData.customAppBar(context),
              SizedBox(height:50),
                Image.asset(AssetData.sunnyDay),
                SizedBox(height:30),
              TextData.pageName(content: "Acordul a fost \n confirmat"),
              SizedBox(height:20),
              TextData.centerText(content: "Mulțumim! Acum poți continua experiența FutureMe."),
              SizedBox(height:20),  
              AssetData.divider(),
              SizedBox(height:20),
              TextData.centerText(content: "Răspunsurile tale sunt în siguranță. Le folosim pentru a personaliza pașii, interpretările și raportul tău final. Poți merge mai departe în ritmul tău."),
              SizedBox(height: 180,),
              TextData.customButton(content: "Continuă ", onpressed: (){    
                goToNextPage(LoginPage());         
              }),
            ]
          )

          )
        );
    }
}