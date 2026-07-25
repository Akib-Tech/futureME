import 'package:flutter/material.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/feature/authentication/forgot_password.dart';
import 'package:futureme/shared/widgets/app_text_field.dart';
import 'package:futureme/shared/widgets/center_text.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/icon_divider.dart';
import 'package:futureme/shared/widgets/left_bold_text.dart';
import 'package:futureme/shared/widgets/link_text.dart';
import 'package:futureme/shared/widgets/page_title.dart';
import 'package:futureme/shared/widgets/primary_button.dart';
import 'package:futureme/shared/widgets/rounded_card.dart';
import 'package:futureme/shared/widgets/social_sign_in_button.dart';



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
          backgroundColor : AppColors.background,
          body: SingleChildScrollView(
            child: Container(
            padding: EdgeInsets.all(30),
            child:  Column(
            children:[
              CustomAppBar(context),
               SizedBox(height:30),
              PageTitle(content:"Creează-ți contul"),
              SizedBox(height:20),
              CenterText(content: "Contul tău îți păstrează progresul și raportul FutureMe în siguranță."),
              SizedBox(height:20),
               LeftBoldText(content: "Email"),
               SizedBox(height:10),
              RoundedCard(contents: [
                AppTextField(hintText: "exemplu@email.com"),
              ]),
              SizedBox(height:20),
               LeftBoldText(content: "Parolă"),
               SizedBox(height:10),
              RoundedCard(contents: [
                AppTextField(hintText: "Alege o parolă", obscureText: true, suffixIcon: const Icon(Icons.visibility_outlined)),
              ]),

              SizedBox(height: 20,),
              PrimaryButton(content: "Creează contul", onpressed: (){
               goToNextPage(ForgotPassword());
              }),
               SizedBox(height: 20,),
               IconDivider(centerText: "sau"),
                SizedBox(height: 20,),
              SocialSignInButton(
                icon: AppAssets.googleIcon,
                label: "Continuă cu Google",
              ),
              SizedBox(
                height: 20,
              ),
              SocialSignInButton(
                icon: AppAssets.appleIcon,
                label: "Continuă cu Apple",
              ),
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
               child: LinkText(content: "Conectează-te")
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
