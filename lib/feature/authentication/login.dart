import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:futureme/core/auth/auth_service.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/di/injectable_init.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/feature/authentication/forgot_password.dart';
import 'package:futureme/feature/authentication/sign_in_screen.dart';
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

    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    bool _isLoading = false;

    void goToNextPage(Widget? nextPage){
      Navigator.push(context,MaterialPageRoute(builder: (context) => nextPage! ));
    }

    Future<void> _signUp() async {
      if (_isLoading) return;
      setState(() => _isLoading = true);
      try {
        await getIt<AuthService>().signUpWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        if (!mounted) return;
        goToNextPage(ForgotPassword());
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(authErrorMessage(e))));
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }

    @override
    void initState(){
      super.initState();
    }

    @override
    void dispose(){
      _emailController.dispose();
      _passwordController.dispose();
      super.dispose();
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
                          AppTextField(hintText: "exemplu@email.com", controller: _emailController, keyboardType: TextInputType.emailAddress),
                        ]),
                        const SizedBox(height:24),
                        LeftBoldText(content: "Parolă"),
                        const SizedBox(height:8),
                        RoundedCard(contents: [
                          AppTextField(hintText: "Alege o parolă", controller: _passwordController, obscureText: true, suffixIcon: const Icon(Icons.visibility_outlined)),
                        ]),

                        const SizedBox(height: 24,),
                        PrimaryButton(
                          content: _isLoading ? "Se creează..." : "Creează contul",
                          onpressed: _isLoading ? null : _signUp,
                        ),
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
                            LinkText(
                              content: "Conectează-te",
                              shrinkWrap: true,
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInScreen()));
                              },
                            ),
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
