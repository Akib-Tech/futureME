import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futureme/feature/onboarding_screen.dart';


import '../core/constants/assets.dart';

class SplashScreen extends StatelessWidget{
      const SplashScreen({super.key});
      
        @override
        Widget build(BuildContext context) {
            return Scaffold(
              body: GestureDetector(
                onTap: (){
                  Navigator.push(context,
                  MaterialPageRoute(builder: 
                  (context) => OnboardingScreen()
                  )
                  );
                } ,
                child: Center(
                child: SvgPicture.asset(AssetData.splashImage), 
              )
              )
            );
        }

}

