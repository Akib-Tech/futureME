import 'package:flutter/material.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/constants/text.dart';
import 'package:futureme/feature/consent_info.dart';

enum AgeBracket {
  young, 
  younger,
  youngest,
  older
}


class AgeSet extends StatefulWidget{
  const AgeSet({super.key});

  @override
  State<AgeSet> createState() => AgeSetState();
}

class AgeSetState extends State<AgeSet>{

    AgeBracket selectedAge = AgeBracket.young;

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
          body: Container(
            padding: EdgeInsets.all(30),
            child:  Column(
            children:[
              AssetData.customAppBar(context),
               SizedBox(height:30),
              TextData.pageName(content:"Pentru o experiență potrivită"),
              SizedBox(height:20),
              TextData.centerText(content: "FutureMe este creat pentru tineri începând cu vârsta de 14 ani. Alege intervalul tău de vârstă, ca să adaptăm pașii următori."),
              SizedBox(height:20),  
              RadioGroup(
                groupValue: selectedAge,
                onChanged: (AgeBracket? value){
                  if(value != null){
                    setState(() {
                      selectedAge =value;
                    });
                  }
                }, 
                child: Column(
                  children:[
              TextData.roundedContainer(
               contents:  [
                    RadioListTile<AgeBracket>(
                      title: TextData.generalText( "Sub 14 ani",),
                      activeColor: Color(TextData.uiHeadingColor),
                      value:AgeBracket.youngest,
                       controlAffinity: ListTileControlAffinity.trailing,
                    )
                  
                ]
              ),
               SizedBox(height:20),  
              TextData.roundedContainer(
                contents: [
                   RadioListTile<AgeBracket>(
                      title: TextData.generalText( "14-15 ani",),
                      activeColor: Color(TextData.uiHeadingColor),
                      value:AgeBracket.younger,
                       controlAffinity: ListTileControlAffinity.trailing,
                    )
                  
                ]
              ),
               SizedBox(height:20),  
              TextData.roundedContainer(
               contents:  [
                  RadioListTile<AgeBracket>(
                      title: TextData.generalText( "16-17 ani",),
                      activeColor: Color(TextData.uiHeadingColor),
                      value:AgeBracket.young,
                       controlAffinity: ListTileControlAffinity.trailing,
                    )
                  
                ]
              ),
               SizedBox(height:20),  
              TextData.roundedContainer(
                contents: [
                  RadioListTile<AgeBracket>(
                      title: TextData.generalText( "+18 ani",),
                      activeColor: Color(TextData.uiHeadingColor),
                      value:AgeBracket.older,
                       controlAffinity: ListTileControlAffinity.trailing,
                    )
                  
                ]
              ),
                ])
                
                ),

              SizedBox(height: 40,),
              TextData.customButton(content: "Continua", onpressed: (){
               goToNextPage(ConsentInfo());
              })
            ]
          )

          )
        );
    }
}