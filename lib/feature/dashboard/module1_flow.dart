import 'package:flutter/material.dart';
import 'package:futureme/feature/chat/chat_flow.dart';
import 'package:futureme/feature/dashboard/dashboard_navigation.dart';
import 'package:futureme/feature/dashboard/templates/module_complete_screen.dart';
import 'package:futureme/feature/dashboard/module_progress.dart';
import 'package:futureme/feature/dashboard/templates/module_feedback_summary_screen.dart';
import 'package:futureme/feature/dashboard/templates/module_introduction_screen.dart';
import 'package:futureme/feature/dashboard/templates/module_question_screen.dart';
import 'package:futureme/feature/dashboard/module2_flow.dart';

/// Wires the Module 1 screens (Figma frames 74:335, 80:408/510/550,
/// 88:521, 86:485) into a single push-based flow, entered from the
/// "Începe Modulul 1" button on the dashboard (ModuleInfo).
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
        onContinue: () => _openQuestion1(context),
      ),
    ),
  );
}

void _openQuestion1(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleQuestionScreen(
        questionNumber: 1,
        totalQuestions: 3,
        question: "Ce te-a adus la FutureMe chiar acum?",
        subtitle: "Poate fi o întrebare, o neliniște, o curiozitate sau pur și simplu faptul că nu știi încă încotro să mergi.",
        placeholder: "Scrie aici orice îți vine în minte...",
        onContinue: (answer) => _openQuestion2(context),
      ),
    ),
  );
}

void _openQuestion2(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleQuestionScreen(
        questionNumber: 2,
        totalQuestions: 3,
        question: "Dacă ai avea o baghetă magică, ce ai vrea să se schimbe pentru tine?",
        subtitle: "Imaginează-ți că, după FutureMe, lucrurile sunt puțin mai clare. Ce ai vrea să fie diferit pentru tine?",
        placeholder: "Scrie aici ce ai vrea să se schimbe...",
        hint: "Poate fi ceva mic sau ceva important. Scrie cum îți vine.",
        onContinue: (answer) => _openQuestion3(context),
      ),
    ),
  );
}

void _openQuestion3(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleQuestionScreen(
        questionNumber: 3,
        totalQuestions: 3,
        question: "Imaginează-ți parcursul tău profesional ideal",
        subtitle:
            "Nu trebuie să alegi o meserie exactă. Gândește-te la un drum în care te simți bine cu ce faci și cu oamenii din jur.",
        placeholder: "Scrie aici cum ți-ai imagina acest parcurs...",
        hint: "Nu trebuie să fie realist sau perfect. Scrie ce îți vine acum.",
        continueLabel: "Finalizează modulul",
        textFieldHeight: 205,
        buttonPinned: false,
        tipsTitle: "Te poți gândi la:",
        tips: const [
          "ce ai face într-o zi obișnuită",
          "cu ce fel de oameni ai lucra",
          "cum te-ai simți în acel rol",
          "cum ai vrea să te privească cei din jur",
        ],
        onContinue: (answer) => _openComplete(context),
      ),
    ),
  );
}

void _openComplete(BuildContext context) {
  ModuleProgress.markCompleted(1);
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleCompleteScreen(
        title: "Modulul 1 este complet",
        message:
            "Ai făcut primul pas. Răspunsurile tale au fost salvate și ne ajută să înțelegem mai bine de unde pornești.",
        encouragementNote: "În continuare, îți arătăm un feedback scurt despre ce ai conturat până acum.",
        onContinue: () => _openFeedbackSummary(context),
        onHome: () => goToDashboard(context),
      ),
    ),
  );
}

void _openFeedbackSummary(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleFeedbackSummaryScreen(
        moduleLabel: "Modulul 1 · Feedback scurt",
        title: "Un început de claritate",
        description:
            "În Modulul 1 ai conturat ce te-a adus aici, ce ai vrea să se schimbe și cum ar putea arăta un drum potrivit pentru tine.",
        summaryItems: const [
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
        ],
        nextModuleLabel: "Urmează Modulul 2",
        nextModuleTitle: "Profil psihologic",
        nextModuleDescription: "Vei explora felul în care gândești, iei decizii și reacționezi în situații diferite.",
        continueLabel: "Continuă cu Modulul 2",
        onContinue: () => startModule2(context),
        onChat: () => openChat(context, contextLabel: "Modulul 1 · Răspunsurile tale", continueLabel: "Continuă cu Modulul 2", onContinue: () => startModule2(context)),
      ),
    ),
  );
}
