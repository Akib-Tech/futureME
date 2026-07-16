import 'package:flutter/material.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/constants/text.dart';

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
               Image.asset(AssetData.sunnyDay),
                          TextData.pageName(content: "Abonamentul tău este activ"),
             SizedBox(height: 20),
          TextData.centerText(content: "Totul este pregătit. Poți începe experiența FutureMe și parcurge pașii în ritmul tău."),
           SizedBox(height: 180,),
              TextData.customButton(content: "Continuă ", onpressed: (){    
                goToNextPage(SuccessPayment());         
              }),
         ] )
          )
    ],)
    )
  )

  );
  }

}