import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:futureme/core/auth/auth_service.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/di/injectable_init.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/feature/authentication/login.dart';
import 'package:futureme/feature/authentication/reset_password_screen.dart';
import 'package:futureme/feature/dashboard/dashboard_navigation.dart';
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

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      await getIt<AuthService>().signInWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (!mounted) return;
      goToDashboard(context);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(authErrorMessage(e))));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar(context),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    PageTitle(content: "Conectează-te"),
                    const SizedBox(height: 16),
                    CenterText(content: "Bine ai revenit! Continuă acolo unde ai rămas.", width: 260),
                    const SizedBox(height: 40),
                    LeftBoldText(content: "Email"),
                    const SizedBox(height: 8),
                    RoundedCard(contents: [
                      AppTextField(
                        hintText: "exemplu@email.com",
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ]),
                    const SizedBox(height: 24),
                    LeftBoldText(content: "Parolă"),
                    const SizedBox(height: 8),
                    RoundedCard(contents: [
                      AppTextField(
                        hintText: "Parola ta",
                        controller: _passwordController,
                        obscureText: true,
                        suffixIcon: const Icon(Icons.visibility_outlined),
                      ),
                    ]),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: LinkText(
                        content: "Ai uitat parola?",
                        shrinkWrap: true,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ResetPasswordScreen()));
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    PrimaryButton(
                      content: _isLoading ? "Se conectează..." : "Conectează-te",
                      onpressed: _isLoading ? null : _signIn,
                    ),
                    const SizedBox(height: 24),
                    IconDivider(centerText: "sau"),
                    const SizedBox(height: 24),
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
                        const Text("Nu ai cont? "),
                        LinkText(
                          content: "Creează unul",
                          shrinkWrap: true,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
