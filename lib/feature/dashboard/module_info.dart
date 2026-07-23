import 'package:flutter/material.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/constants/text.dart';

class ModuleInfo extends StatefulWidget{
    const ModuleInfo({super.key});
    @override
      State<ModuleInfo> createState() => ModuleInfoState();
}

class ModuleInfoState extends State<ModuleInfo> {
    @override
    Widget build(BuildContext context){
      return  Scaffold(
    bottomNavigationBar: AssetData.navBar(),
    backgroundColor: Color(0xFFFEF6F2),
    body: SingleChildScrollView(
    padding: EdgeInsets.all(10),
    scrollDirection:Axis.vertical,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      decoration: BoxDecoration(
            color: const Color(0xFFFEF6F2)
        ),
      child: Column(
        children:[
        TextData.pageName(
          content:"Bună, Andreea",
          textAlign: TextAlign.left),
          SizedBox(height: 20,),
        TextData.leftLightText(
          content: "Mergem pas cu pas. Nu trebuie să ai toate răspunsurile de la început.",
           fontSize: 20,
          ),
          SizedBox(height: 20,),
        _moduleDashBoard(context),
      SizedBox(height: 20,),
      TextData.pageName(content: "Parcursul tău FutureMe",
      textAlign: TextAlign.left,
      fontSize: 18),
      SizedBox(height: 20,),
      TextData.checkIconText(
        color: Color(TextData.dashboardColor),
        icon:Icons.check_box_outline_blank,
        text: "Cunoaștere & context"
      ),
      SizedBox(height: 20,),
      TextData.checkIconText(
        color: Color(TextData.dashboardColor),
        icon:Icons.check_box_outline_blank,
        text: "Profil psihologic"
      ),
      SizedBox(height: 20,),
      TextData.checkIconText(
        color: Color(TextData.dashboardColor),
        icon:Icons.check_box_outline_blank,
        text: "Interese & vocație"
      ),
      SizedBox(height: 20,),
      TextData.checkIconText(
        color: Color(TextData.dashboardColor),
        icon:Icons.check_box_outline_blank,
        text: "Aptitudini & puncte forte"
      ),
      SizedBox(height: 20,),
      TextData.checkIconText(
        color: Color(TextData.dashboardColor),
        icon:Icons.check_box_outline_blank,
        text: "Claritate, recomandări & plan"
      )
      ])
    )
    ),
      );
    }





    Widget _moduleDashBoard(BuildContext context){
      return TextData.roundedContainer(
          contentPadding: EdgeInsets.all(12),
          borderRadius: BorderRadius.circular(22),
          color: Color(TextData.faintColor),
          contents: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
           
            Expanded(child: 
            Column(children: [

            Row(children: [
           Column(
            children: [
               SizedBox(
            child: Image.asset(AssetData.moduleIcon),
           ),
           
            ],
           ),
           SizedBox(
            width: 12,
           ),
            Expanded(
             child: Column(children: [
                  TextData.leftBoldText(content: "Modulul 1",color: Color(0xff211431)),
              SizedBox(height:3,),
              TextData.linkText(content: "Cunoaștere & context",fontSize: 25),
              SizedBox(height: 5,),
              ],)
            ),
            
            ],),
            
              Container(
                padding: EdgeInsets.only(left: 52),
                child: TextData.leftLightText
                (content: "Începem cu câteva întrebări despre tine,  ce îți dorești și ce ai vrea să clarifici.")
          ,
              )
               ] )
           )
          ],),
          SizedBox(height: 10,),
          
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
           Text("0%",
           style: TextStyle(
            fontSize: 20,
            fontFamily: TextData.uiFontFamily,
            color: Color(TextData.uiHeadingColor),
            fontWeight: FontWeight.w900
           ),
           ),
           SizedBox(width: 5,),
           Expanded(child: 
           TextData.leftLightText(content: "completat"),)
          ],),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: TextData.roundedContainer(
              contentPadding: EdgeInsets.symmetric(
                vertical: 0,horizontal: 0
              )

            ),
          ),

          SizedBox(height: 20,),
          TextData.customButton(content: "Începe Modulul 1"),
              SizedBox(height: 20,),

        ]);
    }
}