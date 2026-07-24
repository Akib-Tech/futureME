import 'package:flutter/material.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/feature/dashboard/module_info.dart';
import 'package:futureme/shared/widgets/center_text.dart';
import 'package:futureme/shared/widgets/check_icon_row.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/page_title.dart';
import 'package:futureme/shared/widgets/primary_button.dart';

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
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.background,
          ),
          child: Column(
            children: [
              CustomAppBar(context),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Image.asset(AppAssets.sunnyDay),
                    const SizedBox(height: 20),
                    PageTitle(
                      content: "Plata nu a fost finalizată",
                    ),
                    const SizedBox(height: 30),
                    CenterText(
                      content:
                          "Se pare că plata nu a fost finalizată. Poți încerca din nou sau poți alege alt plan.",
                    ),
                    const SizedBox(height: 30),
                    CheckIconRow(
                      icon:Icons.info,
                      text: "Dacă ți-a fost retrasă suma, verifică istoricul plăților din App Store sau Google Play.",

                    ),
                    const SizedBox(height: 160),
                    PrimaryButton(content: "Încearcă din nou", onpressed: (){
                      goToNextPage(ModuleInfo());
                    }),
                    const SizedBox(height: 20),
                    CenterText(content: "Alege alt plan")
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
