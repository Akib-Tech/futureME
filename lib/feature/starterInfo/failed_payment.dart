import 'package:flutter/material.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/constants/text.dart';
import 'package:futureme/feature/dashboard/module_info.dart';

class FailedPayment extends StatefulWidget {
  const FailedPayment({super.key});

  @override
  State<FailedPayment> createState() => FailedPaymentState();
}

class FailedPaymentState extends State<FailedPayment> {
  void goToNextPage(Widget nextPage) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => nextPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF6F2),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFEF6F2),
          ),
          child: Column(
            children: [
              AssetData.customAppBar(context),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Image.asset(AssetData.sunnyDay),
                    const SizedBox(height: 20),
                    TextData.pageName(
                      content: "Plata nu a fost finalizată",
                    ),
                    const SizedBox(height: 30),
                    TextData.centerText(
                      content:
                          "Se pare că plata nu a fost finalizată. Poți încerca din nou sau poți alege alt plan.",
                    ),
                    const SizedBox(height: 30),
                    TextData.checkIconText(
                      icon:Icons.info,
                      text: "Dacă ți-a fost retrasă suma, verifică istoricul plăților din App Store sau Google Play.",

                    ),
                    const SizedBox(height: 160),
                    TextData.customButton(content: "Încearcă din nou", onpressed: (){
                      goToNextPage(ModuleInfo());
                    }),
                    const SizedBox(height: 20),
                    TextData.centerText(content: "Alege alt plan")
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