import 'package:flutter/material.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/constants/text.dart';
import 'package:futureme/feature/email_consent.dart';


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
          backgroundColor : Color(TextData.backgroundColor),
          body: Container(
            padding: EdgeInsets.all(30),
            child:  Column(
            children:[
            
              AssetData.customAppBar(context),
              SizedBox(height:50),
                Image.asset(AssetData.sunnyDay),
                SizedBox(height:30),
              TextData.pageName(content: "Avem nevoie de acordul unui părinte"),
              SizedBox(height:20),
              TextData.centerText(content: "Pentru vârsta ta, este nevoie ca un părinte sau tutore legal să își dea acordul înainte să continui evaluarea."),
              SizedBox(height:20),  
              AssetData.divider(),
              SizedBox(height:20),
              TextData.centerText(content: "După acest pas, vei putea merge mai departe în ritmul tău."),
              SizedBox(height: 70,),
              TextData.customButton(content: "Continuă cu acordul", onpressed: (){    
                goToNextPage(EmailConsent());         
              }),
              SizedBox(height: 20,),
               TextData.tagText(content: "Revin mai târziu")
            ]
          )

          )
        );
    }
}