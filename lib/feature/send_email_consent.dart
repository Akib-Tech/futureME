import 'package:flutter/material.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/constants/text.dart';
import 'package:futureme/feature/confirm_consent_info.dart';


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
          backgroundColor : Color(TextData.backgroundColor),
          body: Container(
            padding: EdgeInsets.all(20),
            child:  Column(
            children:[
            
              AssetData.customAppBar(context),
              SizedBox(height:20),
                Image.asset(AssetData.sunnyDay),
                SizedBox(height:30),
              TextData.pageName(content: "Așteptăm acordul"),
              SizedBox(height:50),
              TextData.centerText(content: "Am trimis linkul către părintele sau tutorele tău. După confirmare, vei putea continua \n în FutureMe."),
           
              SizedBox(height: 300,),
              TextData.customButton(content: "Verifică acordul", onpressed: (){      
                goToNextPage(ConfirmConsent());       
              }),
              SizedBox(height: 5,),
               TextData.tagText(content: "Schimbă adresa de email")
            ]
          )

          )
        );
    }
}