import 'package:flutter/material.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/feature/age_gate/age_sixteen_twenty_screen.dart';
import 'package:futureme/feature/consent/consent_info.dart';
import 'package:futureme/feature/age_gate/under_fourteen_restricted_screen.dart';
import 'package:futureme/shared/widgets/center_text.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/page_title.dart';
import 'package:futureme/shared/widgets/plain_text.dart';
import 'package:futureme/shared/widgets/primary_button.dart';
import 'package:futureme/shared/widgets/rounded_card.dart';

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

    AgeBracket selectedAge = AgeBracket.younger;

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
          backgroundColor : AppColors.background,
          body: Container(
            padding: EdgeInsets.all(30),
            child:  Column(
            children:[
              CustomAppBar(context),
               SizedBox(height:30),
              PageTitle(content:"Pentru o experiență potrivită"),
              SizedBox(height:20),
              CenterText(content: "FutureMe este creat pentru tineri începând cu vârsta de 14 ani. Alege intervalul tău de vârstă, ca să adaptăm pașii următori."),
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
              RoundedCard(
               contents:  [
                    RadioListTile<AgeBracket>(
                      title: PlainText("Sub 14 ani"),
                      activeColor: AppColors.uiHeading,
                      value:AgeBracket.youngest,
                       controlAffinity: ListTileControlAffinity.trailing,
                    )

                ]
              ),
               SizedBox(height:20),
              RoundedCard(
                contents: [
                   RadioListTile<AgeBracket>(
                      title: PlainText("14-15 ani"),
                      activeColor: AppColors.uiHeading,
                      value:AgeBracket.younger,
                       controlAffinity: ListTileControlAffinity.trailing,
                    )

                ]
              ),
               SizedBox(height:20),
              RoundedCard(
               contents:  [
                  RadioListTile<AgeBracket>(
                      title: PlainText("16-17 ani"),
                      activeColor: AppColors.uiHeading,
                      value:AgeBracket.young,
                       controlAffinity: ListTileControlAffinity.trailing,
                    )

                ]
              ),
               SizedBox(height:20),
              RoundedCard(
                contents: [
                  RadioListTile<AgeBracket>(
                      title: PlainText("+18 ani"),
                      activeColor: AppColors.uiHeading,
                      value:AgeBracket.older,
                       controlAffinity: ListTileControlAffinity.trailing,
                    )

                ]
              ),
                ])

                ),

              SizedBox(height: 40,),
              PrimaryButton(content: "Continuă", onpressed: (){
               switch (selectedAge) {
                 case AgeBracket.youngest:
                   goToNextPage(const UnderFourteenRestrictedScreen());
                 case AgeBracket.younger:
                   goToNextPage(ConsentInfo());
                 case AgeBracket.young:
                 case AgeBracket.older:
                   goToNextPage(const AgeSixteenTwentyScreen());
               }
              })
            ]
          )

          )
        );
    }
}
