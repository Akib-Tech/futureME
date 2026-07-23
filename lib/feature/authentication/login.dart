import 'package:flutter/material.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/constants/text.dart';
import 'package:futureme/feature/authentication/forgot_password.dart';



class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>{


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
              TextData.pageName(content:"Creează-ți contul"),
              SizedBox(height:20),
              TextData.centerText(content: "Contul tău îți păstrează progresul și raportul FutureMe în siguranță."),
              SizedBox(height:20),  
               TextData.leftBoldText(content: "Email"),
               SizedBox(height:10), 
              TextData.roundedContainer(contents: [
                AssetData.textForm(),
              ]),
              SizedBox(height:20),  
               TextData.leftBoldText(content: "Parolă"),
               SizedBox(height:10), 
              TextData.roundedContainer(contents: [
                AssetData.textForm(),
              ]),

              SizedBox(height: 20,),
              TextData.customButton(content: "Creează contul", onpressed: (){
               goToNextPage(ForgotPassword());
              }),
               SizedBox(height: 20,),
               AssetData.divider(),
                SizedBox(height: 20,),
              TextData.roundedContainer(

                contentPadding: EdgeInsets.symmetric(horizontal: 90,vertical: 15),
                contents: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Image.asset(AssetData.googleIcon),
                   SizedBox(width: 6,),
                  Expanded(child: TextData.linkText(content: "Continuă cu Google")
                  ,)
                ],)
              ]),
              SizedBox(
                height: 20,
              ),
               TextData.roundedContainer(
                 contentPadding: EdgeInsets.symmetric(horizontal: 90,vertical: 15),
                
                contents: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Image.asset(AssetData.appleIcon),
                  SizedBox(width: 6,),
                  Expanded(
                  child:TextData.linkText(
                    content: "Continuă cu Google",
                   )
                  )
                
                ],)
              ]),
              SizedBox(
                height: 20,
              ),
              
              Container(
                padding: EdgeInsets.symmetric(horizontal: 70),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text( "Ai deja cont? "),
                SizedBox(
                width: 5,
              ),
               Expanded(
               child: TextData.linkText(content: "Conectează-te")
                ,)
              ],),
              )

            ]
          )

          ),
          )
        );
    }
}