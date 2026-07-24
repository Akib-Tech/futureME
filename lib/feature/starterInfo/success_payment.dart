import 'package:flutter/material.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/feature/starterInfo/failed_payment.dart';
import 'package:futureme/shared/widgets/center_text.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/page_title.dart';
import 'package:futureme/shared/widgets/primary_button.dart';

class SuccessPayment extends StatefulWidget{
    const SuccessPayment({super.key});

    @override
    State<SuccessPayment> createState() => SuccessPaymentState();
}

class SuccessPaymentState extends State<SuccessPayment>{
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
            child: Column(
              children: [
               Image.asset(AppAssets.sunnyDay),
                          PageTitle(content: "Abonamentul tău este activ"),
             SizedBox(height: 20),
          CenterText(content: "Totul este pregătit. Poți începe experiența FutureMe și parcurge pașii în ritmul tău."),
           SizedBox(height: 350,),
              PrimaryButton(content: "Continuă ", onpressed: (){
                goToNextPage(FailedPayment());
              }),
         ] )
          )
    ],)
    )
  )

  );
  }

}
