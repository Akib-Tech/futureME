import 'package:flutter/material.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/feature/starterInfo/success_payment.dart';
import 'package:futureme/shared/widgets/center_text.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/page_title.dart';
import 'package:futureme/shared/widgets/primary_button.dart';

class PricingPackage extends StatefulWidget{
    const PricingPackage({super.key});

    @override
    State<PricingPackage> createState() => PricingPackageState();
}

class PricingPackageState extends State<PricingPackage>{
   void goToNextPage(Widget? nextPage){
      Navigator.push(context,MaterialPageRoute(builder: (context) => nextPage! ));
  }

@override
Widget build(BuildContext context){
  return Scaffold(
    backgroundColor: AppColors.background,
    body: SingleChildScrollView(
    padding: EdgeInsets.all(0),
    scrollDirection:Axis.vertical,
    child: Container(
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
            color: AppColors.background
        ),
      child:  Column(
        children: [

              CustomAppBar(context),
               SizedBox(height:30),
          Container(
            padding:EdgeInsets.symmetric(horizontal: 20,vertical: 0),
            child: Column(children: [
                          PageTitle(content: "Alege planul potrivit pentru tine"),
             SizedBox(height: 20),
          CenterText(content: "Ambele planuri includ experiența FutureMe completă: modulele ghidate, raportul personalizat și audio-ul final."),
            SizedBox(height: 20),

            SizedBox(height: 410),
           PrimaryButton(content:"Continuă cu planul anual",onpressed: (){
              goToNextPage(SuccessPayment());
            }),
           SizedBox(height: 20),
            CenterText(content: "Plata este securizată prin magazinul aplicației. Abonamentul se reînnoiește automat și poate fi gestionat oricând.")
         ] )
          )
    ],)
    )
  )

  );
  }

}
