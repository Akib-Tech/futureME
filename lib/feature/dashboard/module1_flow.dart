import 'package:flutter/material.dart';
import 'package:futureme/core/data/ai_content_repository.dart';
import 'package:futureme/core/di/injectable_init.dart';
import 'package:futureme/feature/authentication/pending_signup_data.dart';
import 'package:futureme/feature/chat/chat_flow.dart';
import 'package:futureme/feature/dashboard/dashboard_navigation.dart';
import 'package:futureme/feature/dashboard/module_answers.dart';
import 'package:futureme/feature/dashboard/templates/module_complete_screen.dart';
import 'package:futureme/feature/dashboard/module_progress.dart';
import 'package:futureme/feature/dashboard/templates/module_feedback_summary_screen.dart';
import 'package:futureme/feature/dashboard/templates/module_introduction_screen.dart';
import 'package:futureme/feature/dashboard/templates/module_loading_screen.dart';
import 'package:futureme/feature/dashboard/templates/module_question_screen.dart';
import 'package:futureme/feature/dashboard/module2_flow.dart';

/// Wires the Module 1 screens (Figma frames 74:335, 80:408/510/550,
/// 88:521, 86:485) into a single push-based flow, entered from the
/// "Începe Modulul 1" button on the dashboard (ModuleInfo).
///
/// The 3 questions and the closing feedback are generated per-user by the
/// `generateModule1Questions` / `generateInsight` Cloud Functions
/// ([AiContentRepository]). If either call fails (not deployed, offline,
/// model error) the flow falls back to the fixed content below, so the
/// module always works.

const String _defaultHint = "Nu trebuie să scrii perfect. Spune doar ce simți.";

const List<GeneratedQuestion> _fallbackQuestions = [
  GeneratedQuestion(
    question: "Ce te-a adus la FutureMe chiar acum?",
    subtitle:
        "Poate fi o întrebare, o neliniște, o curiozitate sau pur și simplu faptul că nu știi încă încotro să mergi.",
    placeholder: "Scrie aici orice îți vine în minte...",
  ),
  GeneratedQuestion(
    question: "Dacă ai avea o baghetă magică, ce ai vrea să se schimbe pentru tine?",
    subtitle:
        "Imaginează-ți că, după FutureMe, lucrurile sunt puțin mai clare. Ce ai vrea să fie diferit pentru tine?",
    placeholder: "Scrie aici ce ai vrea să se schimbe...",
    hint: "Poate fi ceva mic sau ceva important. Scrie cum îți vine.",
  ),
  GeneratedQuestion(
    question: "Imaginează-ți parcursul tău profesional ideal",
    subtitle:
        "Nu trebuie să alegi o meserie exactă. Gândește-te la un drum în care te simți bine cu ce faci și cu oamenii din jur.",
    placeholder: "Scrie aici cum ți-ai imagina acest parcurs...",
    hint: "Nu trebuie să fie realist sau perfect. Scrie ce îți vine acum.",
  ),
];

const List<String> _fallbackLastQuestionTips = [
  "ce ai face într-o zi obișnuită",
  "cu ce fel de oameni ai lucra",
  "cum te-ai simți în acel rol",
  "cum ai vrea să te privească cei din jur",
];

const List<SummaryItem> _fallbackFeedbackItems = [
  SummaryItem(
    icon: Icons.wb_sunny_outlined,
    title: "Claritate",
    description: "Ai început să te gândești la ce ai vrea să înțelegi mai bine.",
  ),
  SummaryItem(
    icon: Icons.autorenew,
    title: "Schimbare",
    description: "Ai numit ce ai vrea să fie diferit pentru tine.",
  ),
  SummaryItem(
    icon: Icons.explore_outlined,
    title: "Direcție",
    description: "Ai imaginat un parcurs care s-ar putea simți mai potrivit pentru tine.",
  ),
];

const List<IconData> _insightIcons = [
  Icons.wb_sunny_outlined,
  Icons.autorenew,
  Icons.explore_outlined,
  Icons.psychology_outlined,
];

SummaryLevel? _toSummaryLevel(InsightLevel? level) => switch (level) {
      InsightLevel.low => SummaryLevel.low,
      InsightLevel.medium => SummaryLevel.medium,
      InsightLevel.high => SummaryLevel.high,
      null => null,
    };

class _Module1Questions {
  const _Module1Questions(this.items, {required this.isFallback});

  final List<GeneratedQuestion> items;
  final bool isFallback;
}

void startModule1(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleIntroductionScreen(
        moduleLabel: "Modulul 1",
        moduleTitle: "Cunoaștere & context",
        description:
            "Începem cu câteva întrebări simple despre tine: ce te-a adus aici, ce ți-ai dori să se schimbe și ce ai vrea să înțelegi mai clar.",
        nextSteps: const [
          "3 întrebări ghidate",
          "Răspunzi în ritmul tău",
          "Nu există răspunsuri greșite",
        ],
        continueLabel: "Începe Modulul 1",
        onContinue: () {
          markModuleStarted('module1');
          Navigator.push(context, MaterialPageRoute(builder: (context) => const _Module1QuestionsGate()));
        },
      ),
    ),
  );
}

/// Fetches the per-user questions (or falls back), then replaces itself with
/// the first question screen.
class _Module1QuestionsGate extends StatefulWidget {
  const _Module1QuestionsGate();

  @override
  State<_Module1QuestionsGate> createState() => _Module1QuestionsGateState();
}

class _Module1QuestionsGateState extends State<_Module1QuestionsGate> {
  @override
  void initState() {
    super.initState();
    _resolve();
  }

  Future<void> _resolve() async {
    final fetched = await getIt<AiContentRepository>().module1Questions(ageBracket: PendingSignupData.ageBracket);
    if (!mounted) return;
    final questions = fetched != null
        ? _Module1Questions(fetched, isFallback: false)
        : const _Module1Questions(_fallbackQuestions, isFallback: true);
    _openQuestion(context, questions, 0, const [], replace: true);
  }

  @override
  Widget build(BuildContext context) => const ModuleLoadingScreen(
        moduleLabel: "Modulul 1",
        title: "Pregătim întrebările",
        description: "Adaptăm câteva întrebări pentru tine. Durează câteva secunde.",
        reminderText: "Nu există răspunsuri greșite.",
      );
}

void _openQuestion(
  BuildContext context,
  _Module1Questions questions,
  int index,
  List<String> collected, {
  bool replace = false,
}) {
  final route = MaterialPageRoute<void>(
    builder: (context) {
      final q = questions.items[index];
      final isLast = index == questions.items.length - 1;
      final questionKey = 'q${index + 1}';
      return ModuleQuestionScreen(
        questionNumber: index + 1,
        totalQuestions: questions.items.length,
        question: q.question,
        subtitle: q.subtitle,
        placeholder: q.placeholder,
        hint: q.hint ?? _defaultHint,
        continueLabel: isLast ? "Finalizează modulul" : "Continuă",
        textFieldHeight: isLast ? 205 : 170,
        buttonPinned: !isLast,
        tipsTitle: isLast && questions.isFallback ? "Te poți gândi la:" : null,
        tips: isLast && questions.isFallback ? _fallbackLastQuestionTips : null,
        onAutosave: (answer) =>
            saveModuleAnswer('module1', questionKey, type: 'text', value: answer, questionNumber: index + 1),
        onContinue: (answer) {
          saveModuleAnswer('module1', questionKey, type: 'text', value: answer, questionNumber: index + 1);
          final next = [...collected, answer];
          if (isLast) {
            _openComplete(context, next);
          } else {
            _openQuestion(context, questions, index + 1, next);
          }
        },
      );
    },
  );
  if (replace) {
    Navigator.pushReplacement(context, route);
  } else {
    Navigator.push(context, route);
  }
}

void _openComplete(BuildContext context, List<String> answers) {
  ModuleProgress.markCompleted(1);
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleCompleteScreen(
        title: "Modulul 1 este complet",
        message:
            "Ai făcut primul pas. Răspunsurile tale au fost salvate și ne ajută să înțelegem mai bine de unde pornești.",
        encouragementNote: "În continuare, îți arătăm un feedback scurt despre ce ai conturat până acum.",
        onContinue: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => _Module1FeedbackGate(answers)),
        ),
        onHome: () => goToDashboard(context),
      ),
    ),
  );
}

/// Fetches the per-user feedback (or falls back), then replaces itself with
/// the feedback summary screen.
class _Module1FeedbackGate extends StatefulWidget {
  const _Module1FeedbackGate(this.answers);

  final List<String> answers;

  @override
  State<_Module1FeedbackGate> createState() => _Module1FeedbackGateState();
}

class _Module1FeedbackGateState extends State<_Module1FeedbackGate> {
  @override
  void initState() {
    super.initState();
    _resolve();
  }

  Future<void> _resolve() async {
    final payload = [
      for (int i = 0; i < widget.answers.length; i++)
        {'questionKey': 'q${i + 1}', 'type': 'text', 'value': widget.answers[i]},
    ];
    final insight = await getIt<AiContentRepository>().insight(scope: 'module1', answers: payload);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _feedbackScreen(context, insight)),
    );
  }

  @override
  Widget build(BuildContext context) => const ModuleLoadingScreen(
        moduleLabel: "Modulul 1 · Feedback",
        title: "Pregătim feedbackul tău",
        description: "Ne uităm peste răspunsurile tale. Durează câteva secunde.",
        reminderText: "Acesta este un reper, nu o etichetă.",
      );
}

Widget _feedbackScreen(BuildContext context, GeneratedInsight? insight) {
  final summaryItems = insight != null
      ? [
          for (int i = 0; i < insight.items.length; i++)
            SummaryItem(
              icon: _insightIcons[i % _insightIcons.length],
              title: insight.items[i].title,
              description: insight.items[i].description,
              level: _toSummaryLevel(insight.items[i].level),
            ),
        ]
      : _fallbackFeedbackItems;

  return ModuleFeedbackSummaryScreen(
    moduleLabel: "Modulul 1 · Feedback scurt",
    title: "Un început de claritate",
    description:
        "În Modulul 1 ai conturat ce te-a adus aici, ce ai vrea să se schimbe și cum ar putea arăta un drum potrivit pentru tine.",
    profileLabel: insight?.profileLabel,
    profileValue: insight?.profileValue,
    profileDescription: insight?.profileDescription,
    summaryItems: summaryItems,
    nextModuleLabel: "Urmează Modulul 2",
    nextModuleTitle: "Profil psihologic",
    nextModuleDescription: "Vei explora felul în care gândești, iei decizii și reacționezi în situații diferite.",
    continueLabel: "Continuă cu Modulul 2",
    onContinue: () => startModule2(context),
    onChat: () => openChat(
      context,
      contextLabel: "Modulul 1 · Răspunsurile tale",
      continueLabel: "Continuă cu Modulul 2",
      onContinue: () => startModule2(context),
    ),
  );
}
