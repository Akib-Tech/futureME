import 'package:flutter/material.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/constants/text.dart';
import 'package:futureme/feature/send_email_consent.dart';

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
          backgroundColor : Color(TextData.backgroundColor),
          body: Container(
            padding: EdgeInsets.all(20),
            child:  Column(
            children:[
            
              AssetData.customAppBar(context),
              SizedBox(height:20),
                Image.asset(AssetData.sunnyDay),
                SizedBox(height:30),
              TextData.pageName(content:"Trimitem cererea pentru acord"),
              SizedBox(height:20),
              TextData.centerText(content: "Introdu adresa de email a unui părinte sau tutore. Îi vom trimite un link unde poate citi informțiile despre FutureMe și își poate da acordul."),
           
              SizedBox(height: 30,),
              TextData.roundedContainer(
                [
                  AssetData.textForm()
                ]
              ),
              SizedBox(height: 5,),
              TextData.leftLightText(content: "Nu vom trimite materiale promoționale pe această adresă."),
              SizedBox(height: 80,),
              TextData.customButton(content: "Trimite cererea", onpressed: (){             
                goToNextPage(SendEmailConsent());
              }),
              SizedBox(height: 5,),
               TextData.tagText("Revin mai târziu")
            ]
          )

          )
        );
    }
}