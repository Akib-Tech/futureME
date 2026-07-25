import 'package:flutter/material.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/feature/consent/confirm_consent_info.dart';
import 'package:futureme/shared/widgets/center_text.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/page_title.dart';
import 'package:futureme/shared/widgets/primary_button.dart';
import 'package:futureme/shared/widgets/sun_badge_icon.dart';
import 'package:futureme/shared/widgets/tag_button.dart';


class SendEmailConsent extends StatefulWidget{
  const SendEmailConsent({super.key});

  @override
  State<SendEmailConsent> createState() => SendEmailConsentState();
}

class SendEmailConsentState extends State<SendEmailConsent>{


    void goToNextPage(Widget nextPage){
      Navigator.push(context,MaterialPageRoute(builder: (context) => nextPage ));
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
            child: Column(
              children: [
                CustomAppBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        SunBadgeIcon(badgeIcon: Icons.access_time_rounded, badgeColor: AppColors.statusInfoFg),
                        const SizedBox(height: 32),
                        PageTitle(content: "Așteptăm acordul", width: 274),
                        const SizedBox(height: 24),
                        CenterText(content: "Am trimis linkul către părintele sau tutorele tău. După confirmare, vei putea continua în FutureMe.", width: 315,),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Column(
                    children: [
                      PrimaryButton(content: "Verifică acordul", onpressed: (){
                        goToNextPage(ConfirmConsent());
                      }),
                      const SizedBox(height: 8),
                      TagButton(content: "Schimbă adresa de email", onTap: () => Navigator.pop(context)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
    }
}
