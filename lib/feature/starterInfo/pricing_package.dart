import 'package:flutter/material.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/constants/text.dart';
import 'package:futureme/feature/starterInfo/success_payment.dart';

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
                          TextData.pageName(content: "Alege planul potrivit pentru tine"),
             SizedBox(height: 20),
          TextData.centerText(content: "Ambele planuri includ experiența FutureMe completă: modulele ghidate, raportul personalizat și audio-ul final."),
            SizedBox(height: 20),
         
            SizedBox(height: 410),
           TextData.customButton(content:"Continuă cu planul anual",onpressed: (){ 
              goToNextPage(SuccessPayment());
            }),
           SizedBox(height: 20),
            TextData.centerText(content: "Plata este securizată prin magazinul aplicației. Abonamentul se reînnoiește automat și poate fi gestionat oricând.")
         ] )
          )
    ],)
    )
  )

  );
  }

}