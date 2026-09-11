import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:futureme/core/auth/auth_service.dart';
import 'package:futureme/core/di/injectable_init.dart';
import 'package:futureme/core/subscription/subscription_service.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/feature/dashboard/module_info.dart';
import 'package:futureme/firebase_options.dart';
import './feature/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  configureDependencies();

  await getIt<SubscriptionService>().configure();

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      debugShowCheckedModeBanner: false,
      color: AppColors.background,
      theme: ThemeData(
    textTheme: GoogleFonts.rubikTextTheme(),
    // or fontFamily: GoogleFonts.rubik().fontFamily,
   ),
      home: const FirebaseApp(),
    );
  }
}


class FirebaseApp extends StatefulWidget{
    const FirebaseApp({super.key});

    @override
    State<FirebaseApp> createState() => _FirebaseAppState();
}

class _FirebaseAppState extends State<FirebaseApp>{

    @override
    void initState(){
      super.initState();
     /* final  httpClient = getIt<Dio>();
      httpClient.interceptors.clear();

      final networkInspector = NetworkInspector();

      httpClient.interceptors.add(
        DioInterceptor(
          logIsAllowed:true,
          isConsoleLogAllowed: true,
          networkInspector : networkInspector,
          onHttpFinish: (hashCode, title, message) async {
           
          }
        )
      );*/
    }
    @override
    Widget build(BuildContext context){
      return StreamBuilder<User?>(
        stream: getIt<AuthService>().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: SizedBox.shrink());
          }
          final signedIn = snapshot.data != null;
          return Scaffold(
            body: SplashScreen(),
          );
        },
      );
    }
}