import 'package:flutter/material.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/shared/widgets/primary_button.dart';

/// Shared layout for the "Module N - Complete" screens (Figma frame 86:485
/// and its per-module equivalents). The audio waveform is a static visual
/// approximation — no audio asset/playback is wired up yet.
class ModuleCompleteScreen extends StatefulWidget {
  const ModuleCompleteScreen({
    super.key,
    required this.title,
    required this.message,
    required this.encouragementNote,
    required this.onContinue,
    required this.onHome,
    this.audioDuration = "0:35",
    this.continueLabel = "Continuă către feedback",
    this.homeLabel = "Înapoi Acasă",
    this.nextModuleLabel,
    this.nextModuleTitle,
    this.nextModuleDescription,
  });

  final String title;
  final String message;
  final String encouragementNote;
  final String audioDuration;
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
  State<ModuleCompleteScreen> createState() => _ModuleCompleteScreenState();
}

class _ModuleCompleteScreenState extends State<ModuleCompleteScreen> {
  bool _playing = false;

  static const List<double> _waveform = [
    4, 8, 14, 6, 16, 14, 10, 10, 10, 14, 10, 16, 10, 6, 16, 14, 10, 14, 10, 4, 16, 10, 10, 14, 10, 8, 14, 4,
  ];

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
                            widget.title,
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
                            widget.message,
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
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white /* ui-surface-card */,
                              border: Border.all(color: AppColors.border),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: const [
                                BoxShadow(color: Color(0x59CFB2A4), blurRadius: 4, offset: Offset(0, 4)),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Mesaj pentru tine",
                                  style: TextStyle(
                                    color: AppColors.uiHeading /* ui-text-heading */,
                                    fontSize: 16,
                                    fontFamily: AppFonts.body,
                                    fontWeight: FontWeight.w500,
                                    height: 1.375,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "Un scurt mesaj de încurajare înainte să mergi mai departe.",
                                  style: TextStyle(
                                    color: AppColors.uiHeadingSmall /* ui-text-secondary */,
                                    fontSize: 14,
                                    fontFamily: AppFonts.body,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: AppColors.faint /* ui-surface-tint */,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () => setState(() => _playing = !_playing),
                                        child: Container(
                                          padding: const EdgeInsets.all(9),
                                          decoration: const BoxDecoration(
                                            gradient: AppColors.specialGradient,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            _playing ? Icons.pause : Icons.play_arrow,
                                            size: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: SizedBox(
                                          height: 32,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              for (final h in _waveform)
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 1),
                                                  child: Container(
                                                    width: 2,
                                                    height: h,
                                                    decoration: BoxDecoration(
                                                      color: AppColors.grad1.withValues(alpha: 0.66),
                                                      borderRadius: BorderRadius.circular(1),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        widget.audioDuration,
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
                            ),
                          ),
                          if (widget.nextModuleTitle != null) ...[
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
                                    widget.nextModuleLabel ?? "",
                                    style: const TextStyle(
                                      color: AppColors.uiHeadingSmall /* ui-text-secondary */,
                                      fontSize: 12,
                                      fontFamily: AppFonts.body,
                                      fontWeight: FontWeight.w500,
                                      height: 1.33,
                                    ),
                                  ),
                                  Text(
                                    widget.nextModuleTitle!,
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
                                    widget.nextModuleDescription ?? "",
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
                            widget.encouragementNote,
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
                  PrimaryButton(content: widget.continueLabel, onpressed: widget.onContinue),
                  GestureDetector(
                    onTap: widget.onHome,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                      alignment: Alignment.center,
                      child: Text(
                        widget.homeLabel,
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
