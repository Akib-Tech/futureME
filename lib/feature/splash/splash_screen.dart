import 'package:flutter/material.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/feature/onboarding/onboarding_screen.dart';

class SplashScreen extends StatelessWidget{
      const SplashScreen({super.key});

        @override
        Widget build(BuildContext context) {
            return Scaffold(
              backgroundColor: AppColors.background,
              body: GestureDetector(
                onTap: (){
                  Navigator.push(context,
                  MaterialPageRoute(builder:
                  (context) => OnboardingScreen()
                  )
                  );
                } ,
                child: Container(
                  color: AppColors.background,
                  width: double.infinity,
                  height: double.infinity,
                )
              )
            );
        }

}
