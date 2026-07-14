import 'package:flutter/material.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/constants/text.dart';


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
                Image.asset(AssetData.sunnyDay),
              TextData.pageName("Avem nevoie de acordul unui părinte"),
              SizedBox(height:20),
              TextData.centerText("Pentru vârsta ta, este nevoie ca un părinte sau tutore legal să își dea acordul înainte să continui evaluarea."),
              SizedBox(height:20),  
              
              TextData.centerText("După acest pas, vei putea merge mai departe în ritmul tău."),
              SizedBox(height: 40,),
              TextData.customButton(content: "Continua", onpressed: (){
               
              })
            ]
          )

          )
        );
    }
}