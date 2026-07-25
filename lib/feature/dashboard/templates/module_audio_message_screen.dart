import 'package:flutter/material.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/primary_button.dart';

/// Shared layout for Module 5's "Audio Message" (472:2292) and "Guided
/// Audio" (495:2170) screens — a module intro followed by a single audio
/// message card, identical in both frames apart from copy. The waveform
/// is a static visual approximation, same as [ModuleCompleteScreen].
class ModuleAudioMessageScreen extends StatefulWidget {
  const ModuleAudioMessageScreen({
    super.key,
    required this.moduleLabel,
    required this.title,
    required this.description,
    required this.messageTitle,
    required this.messageSubtitle,
    required this.continueLabel,
    required this.onContinue,
    this.infoNote,
    this.audioDuration = "0:35",
  });

  final String moduleLabel;
  final String title;
  final String description;
  final String messageTitle;
  final String messageSubtitle;

  /// Omitted on the "Audio Message" frame (472:2292) — only "Guided Audio"
  /// (495:2170) shows this note.
  final String? infoNote;
  final String audioDuration;
  final String continueLabel;
  final VoidCallback onContinue;

  @override
  State<ModuleAudioMessageScreen> createState() => _ModuleAudioMessageScreenState();
}

class _ModuleAudioMessageScreenState extends State<ModuleAudioMessageScreen> {
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
            CustomAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.moduleLabel,
                      style: const TextStyle(
                        color: AppColors.uiHeadingSmall,
                        fontSize: 16,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w500,
                        height: 1.375,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: AppColors.uiHeading,
                        fontSize: 28,
                        fontFamily: AppFonts.heading,
                        fontWeight: FontWeight.w600,
                        height: 1.21,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.description,
                      style: const TextStyle(
                        color: AppColors.uiHeadingSmall,
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
                        color: Colors.white,
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [BoxShadow(color: Color(0x59CFB2A4), blurRadius: 4, offset: Offset(0, 4))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.messageTitle,
                            style: const TextStyle(
                              color: AppColors.uiHeading,
                              fontSize: 16,
                              fontFamily: AppFonts.body,
                              fontWeight: FontWeight.w500,
                              height: 1.375,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.messageSubtitle,
                            style: const TextStyle(
                              color: AppColors.uiHeadingSmall,
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
                            decoration: BoxDecoration(color: AppColors.faint, borderRadius: BorderRadius.circular(24)),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () => setState(() => _playing = !_playing),
                                  child: Container(
                                    padding: const EdgeInsets.all(9),
                                    decoration: const BoxDecoration(gradient: AppColors.specialGradient, shape: BoxShape.circle),
                                    child: Icon(_playing ? Icons.pause : Icons.play_arrow, size: 14, color: Colors.white),
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
                                    color: AppColors.uiHeadingSmall,
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
                    if (widget.infoNote != null) ...[
                      const SizedBox(height: 24),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(color: AppColors.statusInfoBg, shape: BoxShape.circle),
                            child: const Icon(Icons.info_outline, size: 12, color: AppColors.statusInfoFg),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.infoNote!,
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
                    ],
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: PrimaryButton(content: widget.continueLabel, onpressed: widget.onContinue),
            ),
          ],
        ),
      ),
    );
  }
}
