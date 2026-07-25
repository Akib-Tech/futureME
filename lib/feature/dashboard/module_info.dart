import 'package:flutter/material.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/feature/chat/chat_flow.dart';
import 'package:futureme/feature/dashboard/module1_flow.dart';
import 'package:futureme/feature/dashboard/module2_flow.dart';
import 'package:futureme/feature/dashboard/module3_flow.dart';
import 'package:futureme/feature/dashboard/module4_flow.dart';
import 'package:futureme/feature/dashboard/dashboard_navigation.dart';
import 'package:futureme/feature/dashboard/module5_flow.dart';
import 'package:futureme/feature/dashboard/module_progress.dart';
import 'package:futureme/shared/widgets/app_bottom_nav_bar.dart';
import 'package:futureme/shared/widgets/page_title.dart';
import 'package:futureme/shared/widgets/primary_button.dart';

class _ModuleMeta {
  const _ModuleMeta({required this.label, required this.description, required this.startLabel, required this.onStart});

  /// Roadmap step label, also used as the dashboard card's headline
  /// (Figma frame 86:1433 uses the same text for both).
  final String label;

  /// PLACEHOLDER CONTENT for modules 3-5: Figma only has dedicated
  /// dashboard-card copy for Modules 1 (61:271) and 2 (86:1433). These
  /// are one-sentence paraphrases of each module's own verified
  /// Introduction-screen description, not fabricated new content.
  final String description;
  final String startLabel;
  final void Function(BuildContext) onStart;
}

const List<_ModuleMeta> _modules = [
  _ModuleMeta(
    label: "Cunoaștere & context",
    description: "Începem cu câteva întrebări despre tine, ce îți dorești și ce ai vrea să clarifici.",
    startLabel: "Începe Modulul 1",
    onStart: startModule1,
  ),
  _ModuleMeta(
    label: "Profil psihologic",
    description: "În acest modul explorezi felul în care gândești, iei decizii și reacționezi în situații diferite.",
    startLabel: "Începe Modulul 2",
    onStart: startModule2,
  ),
  _ModuleMeta(
    label: "Interese & vocație",
    description: "Descoperi ce activități îți stârnesc curiozitatea și în ce medii te simți mai în largul tău.",
    startLabel: "Începe Modulul 3",
    onStart: startModule3,
  ),
  _ModuleMeta(
    label: "Aptitudini & puncte forte",
    description: "Descoperi ce îți vine mai natural și ce puncte forte poți dezvolta mai departe.",
    startLabel: "Începe Modulul 4",
    onStart: startModule4,
  ),
  _ModuleMeta(
    label: "Claritate, recomandări & plan",
    description: "Punem cap la cap reperele descoperite și conturăm direcții și pași concreți pentru tine.",
    startLabel: "Începe Modulul 5",
    onStart: startModule5,
  ),
];

class ModuleInfo extends StatefulWidget {
  const ModuleInfo({super.key});
  @override
  State<ModuleInfo> createState() => ModuleInfoState();
}

class ModuleInfoState extends State<ModuleInfo> {
  @override
  Widget build(BuildContext context) {
    final completed = ModuleProgress.completedModules;
    final isComplete = ModuleProgress.isAllComplete;
    final currentIndex = isComplete ? 4 : completed; // 0-based index into _modules

    return Scaffold(
      bottomNavigationBar: AppBottomNavBar(
        onHomeTap: () {},
        onChatTap: () => openChat(context, contextLabel: "Raportul tău · Repere de până acum"),
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        scrollDirection: Axis.vertical,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          decoration: const BoxDecoration(color: AppColors.background),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageTitle(content: "Bună, Andreea", textAlign: TextAlign.left),
              const SizedBox(height: 8),
              Text(
                isComplete
                    ? "Ai încheiat parcursul FutureMe. Poți reveni oricând la rezultatele și reperele descoperite."
                    : "Mergem pas cu pas. Nu trebuie să ai toate răspunsurile de la început.",
                style: const TextStyle(color: AppColors.uiHeadingSmall, fontSize: 16, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5),
              ),
              const SizedBox(height: 20),
              _ModuleCard(currentIndex: currentIndex, isComplete: isComplete),
              const SizedBox(height: 24),
              const Text(
                "Parcursul tău FutureMe",
                style: TextStyle(color: AppColors.uiHeading, fontSize: 20, fontFamily: AppFonts.heading, fontWeight: FontWeight.w500, height: 1.2),
              ),
              const SizedBox(height: 16),
              for (int i = 0; i < _modules.length; i++)
                _RoadmapStepStatus(
                  label: _modules[i].label,
                  state: i < completed
                      ? _StepState.completed
                      : (i == completed && !isComplete)
                      ? _StepState.available
                      : (isComplete ? _StepState.completed : _StepState.upcoming),
                ),
              if (isComplete) ...[
                const SizedBox(height: 24),
                _RetakeCard(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({required this.currentIndex, required this.isComplete});

  final int currentIndex;
  final bool isComplete;

  @override
  Widget build(BuildContext context) {
    final module = _modules[currentIndex];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(color: AppColors.faint, border: Border.all(color: AppColors.borderStrong), borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.borderStrong), image: const DecorationImage(image: AssetImage(AppAssets.moduleIcon), fit: BoxFit.cover)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isComplete ? "Parcurs finalizat" : "Modulul ${currentIndex + 1}",
                      style: const TextStyle(color: AppColors.uiHeadingSmall, fontSize: 16, fontFamily: AppFonts.body, fontWeight: FontWeight.w500, height: 1.375),
                    ),
                    Text(
                      isComplete ? "Ai acum o imagine mai clară despre tine" : module.label,
                      style: const TextStyle(color: AppColors.uiHeading, fontSize: 24, fontFamily: AppFonts.heading, fontWeight: FontWeight.w600, height: 1.25),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isComplete ? "Ai descoperit cum funcționezi, ce te atrage, care sunt punctele tale forte și ce direcții merită explorate mai departe." : module.description,
                      style: const TextStyle(color: AppColors.uiHeadingSmall, fontSize: 14, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                isComplete ? "100%" : "0%",
                style: const TextStyle(color: AppColors.grad1, fontSize: 16, fontFamily: AppFonts.body, fontWeight: FontWeight.w500, height: 1.375),
              ),
              const SizedBox(width: 4),
              const Text(
                "completat",
                style: TextStyle(color: AppColors.uiHeadingSmall, fontSize: 14, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            height: 16,
            decoration: BoxDecoration(color: Colors.white, border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(9999)),
            clipBehavior: Clip.antiAlias,
            child: isComplete
                ? const DecoratedBox(decoration: BoxDecoration(color: AppColors.statusInfoFg))
                : null,
          ),
          const SizedBox(height: 16),
          if (isComplete) ...[
            PrimaryButton(content: "Vezi rezultatele tale", onpressed: () => openChat(context, contextLabel: "Raportul tău · Repere de până acum")),
            const SizedBox(height: 8),
            const Text(
              "Raportul și audio-ul tău ghidat sunt disponibile în secțiunea Raport.",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.uiHeadingSmall, fontSize: 14, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5),
            ),
          ] else
            PrimaryButton(content: module.startLabel, onpressed: () => module.onStart(context)),
        ],
      ),
    );
  }
}

enum _StepState { completed, available, upcoming }

class _RoadmapStepStatus extends StatelessWidget {
  const _RoadmapStepStatus({required this.label, required this.state});

  final String label;
  final _StepState state;

  @override
  Widget build(BuildContext context) {
    final (badgeLabel, badgeBg, badgeBorder, badgeFg) = switch (state) {
      _StepState.completed => ("Finalizat", const Color(0xFFE9F3EE), const Color(0xFFB8D7C8), const Color(0xFF3F7A5F)),
      _StepState.available => ("Disponibil", AppColors.statusInfoBg, const Color(0xFFC9C6EF), AppColors.statusInfoFg),
      _StepState.upcoming => (null, null, null, null),
    };
    final isMuted = state != _StepState.available;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: state == _StepState.completed ? AppColors.grad1 : Colors.transparent,
              border: state == _StepState.completed ? null : Border.all(color: AppColors.borderStrong),
            ),
            child: state == _StepState.completed ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: isMuted ? AppColors.container : AppColors.dashboard,
                fontSize: 16,
                fontFamily: AppFonts.body,
                fontWeight: isMuted ? FontWeight.w400 : FontWeight.w500,
                height: 1.375,
              ),
            ),
          ),
          if (badgeLabel != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: badgeBg, border: Border.all(color: badgeBorder!), borderRadius: BorderRadius.circular(9999)),
              child: Text(badgeLabel, style: TextStyle(color: badgeFg, fontSize: 12, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5)),
            ),
        ],
      ),
    );
  }
}

class _RetakeCard extends StatelessWidget {
  const _RetakeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: AppColors.borderStrong), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.borderStrong), image: const DecorationImage(image: AssetImage(AppAssets.moduleIcon), fit: BoxFit.cover)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Vrei să refaci evaluarea?",
                      style: TextStyle(color: AppColors.uiHeading, fontSize: 16, fontFamily: AppFonts.body, fontWeight: FontWeight.w500, height: 1.375),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "O poți relua atunci când simți că răspunsurile tale nu te mai reprezintă.",
                      style: TextStyle(color: AppColors.uiHeadingSmall, fontSize: 14, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(color: AppColors.statusInfoBg, shape: BoxShape.circle),
                          child: const Icon(Icons.info_outline, size: 10, color: AppColors.statusInfoFg),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "2 din 3 evaluări disponibile luna aceasta",
                          style: TextStyle(color: AppColors.statusInfoFg, fontSize: 12, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              ModuleProgress.completedModules = 0;
              goToDashboard(context);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              decoration: BoxDecoration(color: AppColors.faint, border: Border.all(color: AppColors.grad1), borderRadius: BorderRadius.circular(100)),
              alignment: Alignment.center,
              child: const Text(
                "Reia evaluarea",
                style: TextStyle(color: AppColors.grad1, fontSize: 16, fontFamily: AppFonts.body, fontWeight: FontWeight.w500, height: 1.25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
