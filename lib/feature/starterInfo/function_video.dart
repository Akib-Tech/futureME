import 'package:flutter/material.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/constants/text.dart';
import 'package:futureme/feature/starterInfo/pricing_package.dart';
import 'package:futureme/shared/video_player_screen.dart';

class FunctionVideo extends StatefulWidget{
    const FunctionVideo({super.key});

    @override
    State<FunctionVideo> createState() => FunctionVideoState();
}

class FunctionVideoState extends State<FunctionVideo>{
  void goToNextPage(Widget? nextPage){
      Navigator.push(context,MaterialPageRoute(builder: (context) => nextPage! ));
  }
 
@override
Widget build(BuildContext context){
  return Scaffold(
    backgroundColor: Color(0xFFFEF6F2),
    body: SingleChildScrollView(
    padding: EdgeInsets.all(0),
    scrollDirection:Axis.vertical,
    child: Container(
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
            color: const Color(0xFFFEF6F2)
        ),
      child:  Column(
        children: [
        
              AssetData.customAppBar(context),
               SizedBox(height:30),
          Container(
            padding:EdgeInsets.symmetric(horizontal: 20,vertical: 0),
            child: Column(children: [
                          TextData.pageName(content: "Cum funcționează FutureMe"),
             SizedBox(height: 20),
          TextData.centerText(content: "Înainte să mergem mai departe, ți-am pregătit un mesaj care să îți arate ce urmează și să te ajute să pornești cu mai multă încredere."),
            SizedBox(height: 20),
          TextData.roundedContainer(contents: [
            VideoApp(),
            SizedBox(
              height: 10,
            ),
            TextData.leftBoldText(content: "Cum va decurge experiența"),
            SizedBox(
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.timelapse_rounded,
                color: Color(0xFF6D5D78),
                ),
                Expanded(
                  child:TextData.leftLightText(content: "1 Min"),
                )
                
              ],
            ),
            ),
            
            ],),
            SizedBox(height: 20,),

            SizedBox(
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.check_circle_outline_outlined,
                color: Color(0xFF6D5D78),
                ),
                
                SizedBox(width:5),
                Expanded(
                  child:TextData.leftBoldText(content: "Fără presiune sau răspunsuri perfecte"),
                )
                
              ],
            ),
            ),

             SizedBox(height: 10,),

            SizedBox(
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.check_circle_outline_outlined,
                color: Color(0xFF6D5D78),
                ),
                
                SizedBox(width:5),
                Expanded(
                  child:TextData.leftBoldText(content: "Te descoperi în ritmul tău"),
                )
                
              ],
            ),
            ),

             SizedBox(height: 10,),

            SizedBox(
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.check_circle_outline_outlined,
                color: Color(0xFF6D5D78),
                ),
                SizedBox(width:5),
                Expanded(
                  child:TextData.leftBoldText(content: "Primești claritate la final"),
                )
                
              ],
            ),
            ),
            
            SizedBox(height: 100),
           TextData.customButton(content:"Continuation",onpressed: (){ 
              goToNextPage(PricingPackage());
            }),
         ] )
          )
    ],)
    )
  )

  );
  }

}