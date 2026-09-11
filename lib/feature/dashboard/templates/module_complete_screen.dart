import 'package:flutter/material.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/shared/widgets/primary_button.dart';
import 'package:futureme/shared/widgets/tts_audio_card.dart';

/// Shared layout for the "Module N - Complete" screens (Figma frame 86:485
/// and its per-module equivalents). The audio card actually speaks [message]
/// aloud via on-device text-to-speech (see [TtsAudioCard]).
class ModuleCompleteScreen extends StatelessWidget {
  const ModuleCompleteScreen({
    super.key,
    required this.title,
    required this.message,
    required this.encouragementNote,
    required this.onContinue,
    required this.onHome,
    this.continueLabel = "Continuă către feedback",
    this.homeLabel = "Înapoi Acasă",
    this.nextModuleLabel,
    this.nextModuleTitle,
    this.nextModuleDescription,
  });

  final String title;
  final String message;
  final String encouragementNote;
  final String continueLabel;
  final String homeLabel;

  /// Optional "next module" preview card (Figma frame 191:1371) — shown
  /// between the audio message and the info note, when this Complete
  /// screen is a module-level one rather than a stage-level one.
  final String? nextModuleLabel;
  final String? nextModuleTitle;
  final String? nextModuleDescription;

  final VoidCallback onContinue;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ClipRRect(
                      child: Image.asset(
                        AppAssets.fullOnboardingImage,
                        width: double.infinity,
                        height: 199,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.uiHeading /* ui-text-heading */,
                              fontSize: 28,
                              fontFamily: AppFonts.heading,
                              fontWeight: FontWeight.w600,
                              height: 1.21,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.uiHeadingSmall /* ui-text-secondary */,
                              fontSize: 16,
                              fontFamily: AppFonts.body,
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                              letterSpacing: -0.16,
                            ),
                          ),
                          const SizedBox(height: 40),
                          TtsAudioCard(
                            title: "Mesaj pentru tine",
                            subtitle: "Un scurt mesaj de încurajare înainte să mergi mai departe.",
                            spokenText: message,
                          ),
                          if (nextModuleTitle != null) ...[
                            const SizedBox(height: 24),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.faint /* ui-surface-tint */,
                                border: Border.all(color: AppColors.borderStrong),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    nextModuleLabel ?? "",
                                    style: const TextStyle(
                                      color: AppColors.uiHeadingSmall /* ui-text-secondary */,
                                      fontSize: 12,
                                      fontFamily: AppFonts.body,
                                      fontWeight: FontWeight.w500,
                                      height: 1.33,
                                    ),
                                  ),
                                  Text(
                                    nextModuleTitle!,
                                    style: const TextStyle(
                                      color: AppColors.uiHeading /* ui-text-heading */,
                                      fontSize: 20,
                                      fontFamily: AppFonts.heading,
                                      fontWeight: FontWeight.w500,
                                      height: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    nextModuleDescription ?? "",
                                    style: const TextStyle(
                                      color: AppColors.uiHeadingSmall /* ui-text-secondary */,
                                      fontSize: 14,
                                      fontFamily: AppFonts.body,
                                      fontWeight: FontWeight.w400,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 32),
                          Text(
                            encouragementNote,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.uiHeadingSmall /* ui-text-secondary */,
                              fontSize: 16,
                              fontFamily: AppFonts.body,
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                              letterSpacing: -0.16,
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                children: [
                  PrimaryButton(content: continueLabel, onpressed: onContinue),
                  GestureDetector(
                    onTap: onHome,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                      alignment: Alignment.center,
                      child: Text(
                        homeLabel,
                        style: const TextStyle(
                          color: AppColors.grad1 /* ui-action-secondaryText */,
                          fontSize: 16,
                          fontFamily: AppFonts.body,
                          fontWeight: FontWeight.w500,
                          height: 1.25,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
