import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:network_inspector/common/utils/dio_interceptor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:futureme/core/di/injectable_init.dart';
import 'package:network_inspector/network_inspector.dart';
import './splashscreen/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  configureDependencies();

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      debugShowCheckedModeBanner: false,
      color: Color(0xFFFEF6F2),
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
      return Scaffold(
        body:  SplashScreen()
      );
    }
}