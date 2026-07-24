import 'package:flutter/material.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/shared/widgets/app_bottom_nav_bar.dart';
import 'package:futureme/shared/widgets/check_icon_row.dart';
import 'package:futureme/shared/widgets/left_bold_text.dart';
import 'package:futureme/shared/widgets/left_light_text.dart';
import 'package:futureme/shared/widgets/link_text.dart';
import 'package:futureme/shared/widgets/page_title.dart';
import 'package:futureme/shared/widgets/primary_button.dart';
import 'package:futureme/shared/widgets/rounded_card.dart';

class ModuleInfo extends StatefulWidget{
    const ModuleInfo({super.key});
    @override
      State<ModuleInfo> createState() => ModuleInfoState();
}

class ModuleInfoState extends State<ModuleInfo> {
    @override
    Widget build(BuildContext context){
      return  Scaffold(
    bottomNavigationBar: AppBottomNavBar(),
    backgroundColor: AppColors.background,
    body: SingleChildScrollView(
    padding: EdgeInsets.all(10),
    scrollDirection:Axis.vertical,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      decoration: BoxDecoration(
            color: AppColors.background
        ),
      child: Column(
        children:[
        PageTitle(
          content:"Bună, Andreea",
          textAlign: TextAlign.left),
          SizedBox(height: 20,),
        LeftLightText(
          content: "Mergem pas cu pas. Nu trebuie să ai toate răspunsurile de la început.",
           fontSize: 20,
          ),
          SizedBox(height: 20,),
        _moduleDashBoard(context),
      SizedBox(height: 20,),
      PageTitle(content: "Parcursul tău FutureMe",
      textAlign: TextAlign.left,
      fontSize: 18),
      SizedBox(height: 20,),
      CheckIconRow(
        color: AppColors.dashboard,
        icon:Icons.check_box_outline_blank,
        text: "Cunoaștere & context"
      ),
      SizedBox(height: 20,),
      CheckIconRow(
        color: AppColors.dashboard,
        icon:Icons.check_box_outline_blank,
        text: "Profil psihologic"
      ),
      SizedBox(height: 20,),
      CheckIconRow(
        color: AppColors.dashboard,
        icon:Icons.check_box_outline_blank,
        text: "Interese & vocație"
      ),
      SizedBox(height: 20,),
      CheckIconRow(
        color: AppColors.dashboard,
        icon:Icons.check_box_outline_blank,
        text: "Aptitudini & puncte forte"
      ),
      SizedBox(height: 20,),
      CheckIconRow(
        color: AppColors.dashboard,
        icon:Icons.check_box_outline_blank,
        text: "Claritate, recomandări & plan"
      )
      ])
    )
    ),
      );
    }





    Widget _moduleDashBoard(BuildContext context){
      return RoundedCard(
          contentPadding: EdgeInsets.all(12),
          borderRadius: BorderRadius.circular(22),
          color: AppColors.faint,
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
            child: Image.asset(AppAssets.moduleIcon),
           ),

            ],
           ),
           SizedBox(
            width: 12,
           ),
            Expanded(
             child: Column(children: [
                  LeftBoldText(content: "Modulul 1",color: AppColors.dashboard),
              SizedBox(height:3,),
              LinkText(content: "Cunoaștere & context",fontSize: 25),
              SizedBox(height: 5,),
              ],)
            ),

            ],),

              Container(
                padding: EdgeInsets.only(left: 52),
                child: LeftLightText
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
            fontFamily: AppFonts.heading,
            color: AppColors.uiHeading,
            fontWeight: FontWeight.w900
           ),
           ),
           SizedBox(width: 5,),
           Expanded(child:
           LeftLightText(content: "completat"),)
          ],),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: RoundedCard(
              contentPadding: EdgeInsets.symmetric(
                vertical: 0,horizontal: 0
              )

            ),
          ),

          SizedBox(height: 20,),
          PrimaryButton(content: "Începe Modulul 1"),
              SizedBox(height: 20,),

        ]);
    }
}
