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
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children:[
                  CustomAppBar(context),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        PageTitle(content:"Creează-ți contul"),
                        const SizedBox(height:16),
                        CenterText(content: "Contul tău îți păstrează progresul și raportul FutureMe în siguranță.", width: 260,),
                        const SizedBox(height:40),
                        LeftBoldText(content: "Email"),
                        const SizedBox(height:8),
                        RoundedCard(contents: [
                          AppTextField(hintText: "exemplu@email.com"),
                        ]),
                        const SizedBox(height:24),
                        LeftBoldText(content: "Parolă"),
                        const SizedBox(height:8),
                        RoundedCard(contents: [
                          AppTextField(hintText: "Alege o parolă", obscureText: true, suffixIcon: const Icon(Icons.visibility_outlined)),
                        ]),

                        const SizedBox(height: 24,),
                        PrimaryButton(content: "Creează contul", onpressed: (){
                          goToNextPage(ForgotPassword());
                        }),
                        const SizedBox(height: 24,),
                        IconDivider(centerText: "sau"),
                        const SizedBox(height: 24,),
                        SocialSignInButton(
                          icon: AppAssets.googleIcon,
                          label: "Continuă cu Google",
                        ),
                        const SizedBox(height: 16),
                        SocialSignInButton(
                          icon: AppAssets.appleIcon,
                          label: "Continuă cu Apple",
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Ai deja cont? "),
                            LinkText(content: "Conectează-te", shrinkWrap: true),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ]
              ),
            ),
          )
        );
    }
}
