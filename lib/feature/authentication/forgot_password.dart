import 'package:flutter/material.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/constants/text.dart';
import 'package:futureme/feature/starterInfo/function_video.dart';



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
          backgroundColor : Color(TextData.backgroundColor),
          body: SingleChildScrollView(
            child: Container(
            padding: EdgeInsets.all(30),
            child:  Column(
            children:[
              AssetData.customAppBar(context),
               SizedBox(height:30),
              TextData.pageName(content:"Hai să ne cunoaștem"),
              SizedBox(height:20),
              TextData.centerText(content: "Spune-ne prenumele tău, ca fiecare pas să se simtă puțin mai aproape de tine"),
              SizedBox(height:20),  
               TextData.leftBoldText(content: "Prenume"),
               SizedBox(height:10), 
               TextData.roundedContainer([
                AssetData.textForm(),
              ]),
              SizedBox(height:10), 
               TextData.leftLightText(content:"Îl poți schimba oricând din contul tău."),
              SizedBox(height:350), 
              TextData.customButton(content: "Continua", onpressed: (){
                goToNextPage(FunctionVideo());
              }),

            ]
          )

          ),
          )
        );
    }
}