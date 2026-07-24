import 'package:flutter/material.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/primary_button.dart';

enum SummaryLevel { low, medium, high }

class SummaryItem {
  const SummaryItem({
    required this.icon,
    required this.title,
    required this.description,
    this.level,
    this.badgeLabel,
  });

  final IconData icon;
  final String title;
  final String description;

  /// Optional "Nivel" pill (Figma frame 151:1163) — Mai redus/Moderat/Ridicat,
  /// color-coded low/medium/high.
  final SummaryLevel? level;

  /// Optional free-text trait pill (Figma frame 151:1517) — e.g. "Ansamblu",
  /// "Analitic", "Structurat". Always rendered in the same purple "insight"
  /// style regardless of value. Mutually exclusive with [level] in practice.
  final String? badgeLabel;
}

/// Shared layout for the "Module N - Feedback Summary" / "Stage N - Feedback
/// Summary" screens (Figma frames 88:521, 140:1073 and their per-stage
/// equivalents across modules 2-5).
class ModuleFeedbackSummaryScreen extends StatelessWidget {
  const ModuleFeedbackSummaryScreen({
    super.key,
    required this.moduleLabel,
    required this.title,
    required this.description,
    required this.summaryItems,
    required this.continueLabel,
    required this.onContinue,
    required this.onChat,
    this.profileLabel,
    this.profileValue,
    this.profileDescription,
    this.nextModuleLabel,
    this.nextModuleTitle,
    this.nextModuleDescription,
    this.infoNote = "Poți continua cu următorul modul acum sau poți discuta răspunsurile tale în Chat.",
    this.chatLabel = "Discută răspunsurile în Chat",
  });

  final String moduleLabel;
  final String title;
  final String description;
  final List<SummaryItem> summaryItems;

  /// Optional "Profil orientativ" tinted card (Figma frame 140:1073, Stage
  /// feedback screens only — the Module-level Final Feedback doesn't have it).
  final String? profileLabel;
  final String? profileValue;
  final String? profileDescription;

  /// Optional "next module" preview box — omitted on Stage feedback screens.
  final String? nextModuleLabel;
  final String? nextModuleTitle;
  final String? nextModuleDescription;

  final String infoNote;
  final String chatLabel;
  final String continueLabel;
  final VoidCallback onContinue;
  final VoidCallback onChat;

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
                      moduleLabel,
                      style: const TextStyle(
                        color: AppColors.uiHeadingSmall /* ui-text-secondary */,
                        fontSize: 16,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w500,
                        height: 1.375,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
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
                      description,
                      style: const TextStyle(
                        color: AppColors.uiHeadingSmall /* ui-text-secondary */,
                        fontSize: 16,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        letterSpacing: -0.16,
                      ),
                    ),
                    if (profileValue != null) ...[
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
                              profileLabel ?? "",
                              style: const TextStyle(
                                color: AppColors.uiHeadingSmall /* ui-text-secondary */,
                                fontSize: 12,
                                fontFamily: AppFonts.body,
                                fontWeight: FontWeight.w500,
                                height: 1.33,
                              ),
                            ),
                            Text(
                              profileValue!,
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
                              profileDescription ?? "",
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
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white /* ui-surface-card */,
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(color: Color(0x59CFB2A4), blurRadius: 4, offset: Offset(0, 4)),
                        ],
                      ),
                      child: Column(
                        children: [
                          for (int i = 0; i < summaryItems.length; i++) ...[
                            if (i > 0) ...[
                              const SizedBox(height: 16),
                              Divider(color: AppColors.border, height: 1, thickness: 1),
                              const SizedBox(height: 16),
                            ],
                            _SummaryRow(item: summaryItems[i]),
                          ],
                        ],
                      ),
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
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 43,
                              height: 43,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.borderStrong),
                              ),
                              child: const Icon(Icons.arrow_forward, color: AppColors.uiHeading),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
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
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Row(
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
                            infoNote,
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
              child: Column(
                children: [
                  PrimaryButton(content: continueLabel, onpressed: onContinue),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: onChat,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.grad1),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.chat_bubble_outline, size: 24, color: AppColors.grad1),
                          const SizedBox(width: 8),
                          Text(
                            chatLabel,
                            style: const TextStyle(
                              color: AppColors.grad1 /* ui-action-primary */,
                              fontSize: 16,
                              fontFamily: AppFonts.body,
                              fontWeight: FontWeight.w500,
                              height: 1.25,
                            ),
                          ),
                        ],
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

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.item});

  final SummaryItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 43,
          height: 43,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.borderStrong),
          ),
          child: Icon(item.icon, color: AppColors.uiHeading),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: AppColors.uiHeading /* ui-text-heading */,
                      fontSize: 16,
                      fontFamily: AppFonts.body,
                      fontWeight: FontWeight.w500,
                      height: 1.375,
                    ),
                  ),
                  if (item.level != null) _LevelPill(level: item.level!),
                  if (item.badgeLabel != null) _TraitPill(label: item.badgeLabel!),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                item.description,
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
    );
  }
}

class _TraitPill extends StatelessWidget {
  const _TraitPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF2ECFF) /* ui-insight-primary-bg */,
        border: Border.all(color: const Color(0xFFCDBAF4) /* ui-insight-primary-border */),
        borderRadius: BorderRadius.circular(99999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF3A2384) /* ui-insight-primary-fg */,
          fontSize: 12,
          fontFamily: AppFonts.body,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
      ),
    );
  }
}

class _LevelPill extends StatelessWidget {
  const _LevelPill({required this.level});

  final SummaryLevel level;

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color border, Color fg, String label) = switch (level) {
      SummaryLevel.low => (const Color(0xFFF6F0F6), AppColors.borderStrong, AppColors.uiHeadingSmall, "Mai redus"),
      SummaryLevel.medium => (const Color(0xFFFFF7E8), const Color(0xFFEBCDA6), const Color(0xFF7A4A00), "Moderat"),
      SummaryLevel.high => (const Color(0xFFF2ECFF), const Color(0xFFCDBAF4), const Color(0xFF3A2384), "Ridicat"),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(99999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 12,
          fontFamily: AppFonts.body,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
      ),
    );
  }
}
