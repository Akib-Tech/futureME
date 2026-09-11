import 'package:flutter/material.dart';
import 'package:futureme/core/auth/auth_service.dart';
import 'package:futureme/core/data/user_repository.dart';
import 'package:futureme/core/di/injectable_init.dart';
import 'package:futureme/core/report/report_pdf_actions.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/feature/chat/chat_flow.dart';
import 'package:futureme/feature/dashboard/dashboard_navigation.dart';
import 'package:futureme/feature/dashboard/module_progress.dart';
import 'package:futureme/feature/dashboard/module5/module5_report_preview_screen.dart';
import 'package:futureme/feature/dashboard/templates/module_audio_message_screen.dart';
import 'package:futureme/feature/profile/profile_screen.dart';
import 'package:futureme/feature/resources/resources_screen.dart';
import 'package:futureme/shared/widgets/app_bottom_nav_bar.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/page_title.dart';
import 'package:futureme/shared/widgets/primary_button.dart';

/// Bottom-nav "Raport" tab. A hub for the FutureMe final report: locked
/// until all 5 modules are done, then a preview of the report and its
/// guided audio. The full PDF is generated server-side (not built yet),
/// so a "in pregătire" note is shown while `finalReport.status` is
/// `'not_generated'`.
class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  bool _loading = true;
  String? _reportStatus;
  String? _reportSummary;
  List<Map<String, String>>? _reportSections;

  /// Topic labels shown while the real, AI-generated sections aren't ready
  /// yet (see [_reportSections]).
  static const _fallbackSectionTitles = [
    "Profilul tău psihologic și stilul decizional",
    "Interesele și mediile de lucru care ți se potrivesc",
    "Punctele forte pe care poți construi",
    "Direcții profesionale de explorat",
    "Impactul AI asupra acestor direcții",
    "Opțiuni de formare și planul tău în pași",
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await ModuleProgress.hydrate();
    final uid = getIt<AuthService>().currentUser?.uid;
    String? status;
    String? summary;
    List<Map<String, String>>? sections;
    if (uid != null) {
      try {
        final report = await getIt<UserRepository>().fetchFinalReport(uid);
        status = report?['status'] as String?;
        summary = report?['summary'] as String?;
        final rawSections = report?['sections'] as List?;
        sections = rawSections?.map((e) => Map<String, String>.from(e as Map)).toList();
      } catch (_) {
        status = null;
      }
    }
    if (!mounted) return;
    setState(() {
      _reportStatus = status;
      _reportSummary = summary;
      _reportSections = sections;
      _loading = false;
    });
  }

  String get _userName {
    final user = getIt<AuthService>().currentUser;
    return (user?.displayName?.trim().isNotEmpty ?? false) ? user!.displayName!.trim() : "Contul tău";
  }

  void _openPreview() {
    final sections = _reportSections;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Module5ReportPreviewScreen(
          titleLabel: "Raportul tău",
          primaryLabel: "Ascultă audio-ul ghidat",
          chatLabel: "Discută raportul în Chat",
          summary: _reportSummary,
          sections: sections,
          onDownload: sections == null ? null : () => downloadReportPdf(userName: _userName, summary: _reportSummary, sections: sections),
          onShare: sections == null ? null : () => shareReportPdf(userName: _userName, summary: _reportSummary, sections: sections),
          onPrimary: () {
            Navigator.pop(context);
            _openGuidedAudio();
          },
          onChat: () => openChat(context, contextLabel: "Raportul tău · Repere de până acum"),
        ),
      ),
    );
  }

  void _openGuidedAudio() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ModuleAudioMessageScreen(
          moduleLabel: "Raport · Audio ghidat",
          title: "Un audio ales pentru tine",
          description:
              "Pe baza rezultatelor tale, acesta este audio-ul ghidat care încheie parcursul cu mai multă claritate și încredere în pașii următori.",
          messageTitle: "Încredere în propriul ritm",
          messageSubtitle: "Un audio ghidat care îți susține claritatea și încrederea în propriul ritm.",
          infoNote: "Îl poți asculta oricând. Rămâne disponibil aici, în secțiunea Raport.",
          continueLabel: "Înapoi la raport",
          onContinue: () => Navigator.pop(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final completed = ModuleProgress.completedModules.clamp(0, 5);
    final ready = ModuleProgress.isAllComplete;

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: AppBottomNavBar(
        activeIndex: 2,
        onHomeTap: () => goToDashboard(context),
        onChatTap: () => openChat(context, contextLabel: "Raportul tău · Repere de până acum"),
        onResourcesTap: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ResourcesScreen()),
        ),
        onProfileTap: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(context),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          const PageTitle(content: "Raportul tău", textAlign: TextAlign.left),
                          const SizedBox(height: 16),
                          if (!ready)
                            _LockedState(completed: completed)
                          else
                            _ReadyState(
                              sections: _reportSections,
                              fallbackSectionTitles: _fallbackSectionTitles,
                              inPreparation: _reportStatus != 'ready',
                              onOpenPreview: _openPreview,
                              onOpenAudio: _openGuidedAudio,
                              onChat: () => openChat(context, contextLabel: "Raportul tău · Repere de până acum"),
                            ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LockedState extends StatelessWidget {
  const _LockedState({required this.completed});

  final int completed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.faint,
            border: Border.all(color: AppColors.borderStrong),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.lock_outline, size: 28, color: AppColors.uiHeadingSmall),
              const SizedBox(height: 12),
              const Text(
                "Raportul se deblochează la final",
                style: TextStyle(color: AppColors.uiHeading, fontSize: 18, fontFamily: AppFonts.heading, fontWeight: FontWeight.w600, height: 1.25),
              ),
              const SizedBox(height: 8),
              const Text(
                "Raportul tău personalizat adună tot ce descoperi în cele 5 module. Îl poți vedea după ce termini Modulul 5.",
                style: TextStyle(color: AppColors.uiHeadingSmall, fontSize: 14, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5),
              ),
              const SizedBox(height: 16),
              Text(
                "$completed din 5 module finalizate",
                style: const TextStyle(color: AppColors.dashboard, fontSize: 14, fontFamily: AppFonts.body, fontWeight: FontWeight.w500, height: 1.5),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(9999),
                child: LinearProgressIndicator(
                  value: completed / 5,
                  minHeight: 8,
                  backgroundColor: AppColors.border,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.statusInfoFg),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          content: "Continuă parcursul",
          onpressed: () => goToDashboard(context),
        ),
      ],
    );
  }
}

class _ReadyState extends StatelessWidget {
  const _ReadyState({
    required this.sections,
    required this.fallbackSectionTitles,
    required this.inPreparation,
    required this.onOpenPreview,
    required this.onOpenAudio,
    required this.onChat,
  });

  /// The real, AI-generated sections ({title, body}), or null while not
  /// ready yet — falls back to [fallbackSectionTitles] in that case.
  final List<Map<String, String>>? sections;
  final List<String> fallbackSectionTitles;
  final bool inPreparation;
  final VoidCallback onOpenPreview;
  final VoidCallback onOpenAudio;
  final VoidCallback onChat;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: AppColors.specialGradient,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(999)),
                child: const Text(
                  "Raport personalizat",
                  style: TextStyle(color: Colors.white, fontSize: 12, fontFamily: AppFonts.body, fontWeight: FontWeight.w500, height: 1.4),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Raportul tău FutureMe",
                style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: AppFonts.heading, fontWeight: FontWeight.w600, height: 1.2),
              ),
              const SizedBox(height: 8),
              const Text(
                "Dezvoltă mai pe larg rezultatele din aplicație, cu explicații, recomandări și un plan la care poți reveni oricând.",
                style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Ce conține",
                style: TextStyle(color: AppColors.uiHeading, fontSize: 16, fontFamily: AppFonts.heading, fontWeight: FontWeight.w500, height: 1.25),
              ),
              const SizedBox(height: 12),
              if (sections != null)
                for (final s in sections!) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 3),
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.grad1)),
                        child: const Icon(Icons.check, size: 10, color: AppColors.grad1),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s['title'] ?? '',
                              style: const TextStyle(color: AppColors.uiHeading, fontSize: 14, fontFamily: AppFonts.body, fontWeight: FontWeight.w500, height: 1.5),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              s['body'] ?? '',
                              style: const TextStyle(color: AppColors.dashboard, fontSize: 14, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ]
              else
                for (final title in fallbackSectionTitles) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 3),
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.grad1)),
                        child: const Icon(Icons.check, size: 10, color: AppColors.grad1),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(color: AppColors.dashboard, fontSize: 14, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
            ],
          ),
        ),
        if (inPreparation) ...[
          const SizedBox(height: 16),
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
              const Expanded(
                child: Text(
                  "Versiunea PDF completă a raportului se pregătește și va fi disponibilă în curând. Până atunci poți parcurge previzualizarea și audio-ul ghidat.",
                  style: TextStyle(color: AppColors.statusInfoFg, fontSize: 14, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 24),
        PrimaryButton(content: "Vezi raportul", onpressed: onOpenPreview),
        const SizedBox(height: 8),
        _SecondaryButton(icon: Icons.headphones_outlined, label: "Ascultă audio-ul ghidat", onTap: onOpenAudio),
        const SizedBox(height: 8),
        _SecondaryButton(icon: Icons.chat_bubble_outline, label: "Discută raportul în Chat", onTap: onChat),
      ],
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(border: Border.all(color: AppColors.grad1), borderRadius: BorderRadius.circular(100)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: AppColors.grad1),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(color: AppColors.grad1, fontSize: 16, fontFamily: AppFonts.body, fontWeight: FontWeight.w500, height: 1.25),
            ),
          ],
        ),
      ),
    );
  }
}
