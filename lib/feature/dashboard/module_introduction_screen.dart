import 'package:flutter/material.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/shared/widgets/center_text.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/page_title.dart';
import 'package:futureme/shared/widgets/primary_button.dart';
import 'package:futureme/shared/widgets/rounded_card.dart';

/// Shared layout for the "Module N - Introduction" screens (Figma frames
/// 74:335, 94:600, 217:1335, 258:1677, 315:1620) — identical structure,
/// only the copy and checklist differ per module.
class ModuleIntroductionScreen extends StatelessWidget {
  const ModuleIntroductionScreen({
    super.key,
    required this.moduleLabel,
    required this.moduleTitle,
    required this.description,
    required this.nextSteps,
    required this.continueLabel,
    required this.onContinue,
    this.progressNote = "Progresul tău este salvat, așa că poți reveni oricând la acest modul.",
  });

  final String moduleLabel;
  final String moduleTitle;
  final String description;
  final List<String> nextSteps;
  final String continueLabel;
  final String progressNote;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.borderStrong),
                      ),
                      child: Image.asset(AppAssets.moduleIcon, fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      moduleLabel,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.uiHeadingSmall /* ui-text-secondary */,
                        fontSize: 16,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w500,
                        height: 1.375,
                      ),
                    ),
                    const SizedBox(height: 4),
                    PageTitle(content: moduleTitle),
                    const SizedBox(height: 16),
                    CenterText(content: description),
                    const SizedBox(height: 24),
                    RoundedCard(
                      borderRadius: BorderRadius.circular(16),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      contents: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Ce urmează",
                            style: TextStyle(
                              color: AppColors.uiHeading /* ui-text-heading */,
                              fontSize: 20,
                              fontFamily: AppFonts.heading,
                              fontWeight: FontWeight.w500,
                              height: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        for (int i = 0; i < nextSteps.length; i++) ...[
                          if (i > 0) ...[
                            const SizedBox(height: 16),
                            Divider(color: AppColors.border, height: 1, thickness: 1),
                            const SizedBox(height: 16),
                          ],
                          _NextStepRow(text: nextSteps[i]),
                        ],
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: AppColors.statusInfoBg,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.info_outline,
                            size: 12,
                            color: AppColors.statusInfoFg,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            progressNote,
                            style: const TextStyle(
                              color: AppColors.statusInfoFg,
                              fontSize: 14,
                              fontFamily: AppFonts.body,
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: PrimaryButton(
                content: continueLabel,
                gradient: AppColors.specialGradient,
                onpressed: onContinue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NextStepRow extends StatelessWidget {
  const _NextStepRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.faint /* ui-surface-tint */,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, size: 12, color: AppColors.uiHeading),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.dashboard /* ui-text-primary */,
              fontSize: 16,
              fontFamily: AppFonts.body,
              fontWeight: FontWeight.w400,
              height: 1.5,
              letterSpacing: -0.16,
            ),
          ),
        ),
      ],
    );
  }
}
