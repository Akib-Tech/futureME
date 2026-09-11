import 'package:flutter/material.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/feature/age_gate/age_sixteen_twenty_screen.dart';
import 'package:futureme/feature/authentication/pending_signup_data.dart';
import 'package:futureme/feature/consent/consent_info.dart';
import 'package:futureme/feature/age_gate/under_fourteen_restricted_screen.dart';
import 'package:futureme/shared/widgets/center_text.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/page_title.dart';
import 'package:futureme/shared/widgets/primary_button.dart';

enum AgeBracket {
  youngest, 
  younger,
  young,
  older
}


class AgeSet extends StatefulWidget{
  const AgeSet({super.key});

  @override
  State<AgeSet> createState() => AgeSetState();
}

class AgeSetState extends State<AgeSet>{

    AgeBracket selectedAge = AgeBracket.younger;

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
            child: Column(
              children: [
                CustomAppBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        PageTitle(content: "Pentru o experiență potrivită"),
                        const SizedBox(height: 16),
                        CenterText(content: "FutureMe este creat pentru tineri începând cu vârsta de 14 ani. Alege intervalul tău de vârstă, ca să adaptăm pașii următori."),
                        const SizedBox(height: 40),
                        _AgeOption(
                          label: "Sub 14 ani",
                          selected: selectedAge == AgeBracket.youngest,
                          onTap: () => setState(() => selectedAge = AgeBracket.youngest),
                        ),
                        const SizedBox(height: 16),
                        _AgeOption(
                          label: "14-15 ani",
                          selected: selectedAge == AgeBracket.younger,
                          onTap: () => setState(() => selectedAge = AgeBracket.younger),
                        ),
                        const SizedBox(height: 16),
                        _AgeOption(
                          label: "16-17 ani",
                          selected: selectedAge == AgeBracket.young,
                          onTap: () => setState(() => selectedAge = AgeBracket.young),
                        ),
                        const SizedBox(height: 16),
                        _AgeOption(
                          label: "+18 ani",
                          selected: selectedAge == AgeBracket.older,
                          onTap: () => setState(() => selectedAge = AgeBracket.older),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: PrimaryButton(content: "Continuă", onpressed: (){
                   switch (selectedAge) {
                     case AgeBracket.youngest:
                       PendingSignupData.ageBracket = 'under14';
                       PendingSignupData.consentRequired = false;
                       goToNextPage(const UnderFourteenRestrictedScreen());
                     case AgeBracket.younger:
                       PendingSignupData.ageBracket = '14_15';
                       PendingSignupData.consentRequired = true;
                       goToNextPage(ConsentInfo());
                     case AgeBracket.young:
                       PendingSignupData.ageBracket = '16_17';
                       PendingSignupData.consentRequired = false;
                       goToNextPage(const AgeSixteenTwentyScreen());
                     case AgeBracket.older:
                       PendingSignupData.ageBracket = '18_plus';
                       PendingSignupData.consentRequired = false;
                       goToNextPage(const AgeSixteenTwentyScreen());
                   }
                  }),
                ),
              ],
            ),
          ),
        );
    }
}

class _AgeOption extends StatelessWidget {
  const _AgeOption({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: selected ? AppColors.faint /* ui-surface-tint */ : Colors.white /* ui-surface-card */,
          border: Border.all(color: selected ? AppColors.grad1 : AppColors.border),
          borderRadius: BorderRadius.circular(16),
          boxShadow: selected
              ? const [BoxShadow(color: Color(0x59CFB2A4), blurRadius: 4, offset: Offset(0, 4))]
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: AppColors.dashboard /* ui-text-primary */,
                  fontSize: 16,
                  fontFamily: AppFonts.body,
                  fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                  height: 1.375,
                ),
              ),
            ),
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? AppColors.grad1 : null,
                shape: BoxShape.circle,
                border: selected ? null : Border.all(color: AppColors.border, width: 2),
              ),
              child: selected ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
            ),
          ],
        ),
      ),
    );
  }
}
