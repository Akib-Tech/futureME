import 'package:flutter/material.dart';
import 'package:futureme/feature/chat/chat_flow.dart';
import 'package:futureme/feature/dashboard/dashboard_navigation.dart';
import 'package:futureme/feature/dashboard/module5_flow.dart';
import 'package:futureme/feature/dashboard/templates/module_complete_screen.dart';
import 'package:futureme/feature/dashboard/module_progress.dart';
import 'package:futureme/feature/dashboard/templates/module_final_feedback_screen.dart';
import 'package:futureme/feature/dashboard/templates/module_introduction_screen.dart';
import 'package:futureme/feature/dashboard/templates/module_scale_question_screen.dart';

/// Wires the Module 4 screens ("Aptitudini & puncte forte") into a
/// push-based flow. Unlike Modules 2 and 3, Module 4 is flat: a single
/// set of 40 scale statements with no Roadmap and no per-stage split —
/// straight from the Introduction into the questions, then Final Feedback
/// and Complete.
///
/// PLACEHOLDER CONTENT: Figma gives the item count (40 afirmații scurte)
/// but only ever shows one example statement, so the statement bank below
/// is a small placeholder list, same as Modules 2/3.
const List<String> _statementsPlaceholder = [
  "Îmi place să găsesc soluții pentru probleme mai dificile.",
  "Mă descurc bine când trebuie să explic ceva cuiva pas cu pas.",
  "Prefer să duc un proiect până la capăt, nu doar să încep.",
  "Îmi este ușor să observ tipare sau legături pe care alții le ratează.",
  "Mă simt confortabil să iau decizii pe cont propriu, fără să aștept aprobare.",
];

void startModule4(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleIntroductionScreen(
        moduleLabel: "Modulul 4",
        moduleTitle: "Aptitudini & puncte forte",
        description:
            "În acest modul explorăm ce îți vine mai natural, ce abilități poți dezvolta și ce puncte forte pot susține direcțiile conturate până acum.",
        nextSteps: const [
          "40 de afirmații scurte",
          "Alegi cât de mult ți se potrivește fiecare afirmație",
          "La final, vezi ce aptitudini și zone de potențial ies în evidență",
        ],
        continueLabel: "Începe Modulul 4",
        progressNote: "Nu trebuie să ai toate punctele forte deja formate. Căutăm zonele pe care poți construi mai departe.",
        onContinue: () => _openQuestion(context, 0),
      ),
    ),
  );
}

void _openQuestion(BuildContext context, int index) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleScaleQuestionScreen(
        sectionLabel: "Aptitudini & puncte forte",
        statement: _statementsPlaceholder[index],
        questionNumber: index + 1,
        totalQuestions: _statementsPlaceholder.length,
        onContinue: (selection) {
          if (index + 1 < _statementsPlaceholder.length) {
            _openQuestion(context, index + 1);
          } else {
            _openFinalFeedback(context);
          }
        },
      ),
    ),
  );
}

void _openFinalFeedback(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleFinalFeedbackScreen(
        moduleLabel: "Modulul 4 · Imagine de ansamblu",
        title: "Ce puncte forte se văd mai clar",
        description:
            "Răspunsurile tale arată câteva zone în care îți poate fi mai natural să înveți, să contribui și să construiești mai departe.",
        connectionsTitle: "Puncte forte care ies în evidență",
        connections: const [
          ConnectionItem(
            icon: Icons.psychology_outlined,
            title: "Gândire analitică",
            description: "Pari să ai ușurință în a înțelege situații, a observa legături și a găsi soluții când lucrurile nu sunt simple.",
          ),
          ConnectionItem(
            icon: Icons.forum_outlined,
            title: "Comunicare și colaborare",
            description: "Îți poate fi mai natural să explici, să asculți și să lucrezi cu oameni atunci când există un scop clar.",
          ),
          ConnectionItem(
            icon: Icons.checklist_outlined,
            title: "Organizare și implementare",
            description: "Poți funcționa bine când ai lucruri de dus la capăt, pași clari și un rezultat concret de construit.",
          ),
        ],
        secondConnectionsTitle: "O zonă care merită dezvoltată",
        secondConnections: const [
          ConnectionItem(
            icon: Icons.self_improvement_outlined,
            title: "Autonomie și responsabilitate",
            description:
                "Această zonă poate deveni mai puternică pe măsură ce exersezi să îți organizezi pașii și să duci lucrurile mai departe în ritmul tău.",
          ),
        ],
        infoNote:
            "Aceste puncte forte ne ajută să vedem care dintre direcțiile din Modulul 3 pot fi susținute și în practică, nu doar să pară interesante.",
        continueLabel: "Ascultă mesajul pentru tine",
        chatLabel: "Discută Modulul 4 în Chat",
        onContinue: () => _openModule4Complete(context),
        onChat: () => openChat(context, contextLabel: "Modulul 4 · Imagine de ansamblu", continueLabel: "Ascultă mesajul pentru tine", onContinue: () => _openModule4Complete(context)),
      ),
    ),
  );
}

void _openModule4Complete(BuildContext context) {
  ModuleProgress.markCompleted(4);
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleCompleteScreen(
        title: "Modulul 4 este complet",
        message:
            "Ai explorat ce îți vine mai natural, ce poți dezvolta și ce puncte forte pot susține direcțiile conturate până acum. Ia-ți un moment de pauză înainte să mergi mai departe.",
        encouragementNote: "Nu trebuie să alegi încă. În Modulul 5, transformăm reperele de până acum într-o imagine mai clară.",
        continueLabel: "Continuă cu Modulul 5",
        nextModuleLabel: "Urmează Modulul 5",
        nextModuleTitle: "Drumul tău mai departe",
        nextModuleDescription:
            "Punem împreună ce ai descoperit despre tine: ce îți dorești, cum funcționezi, ce te atrage și ce puncte forte se văd mai clar. Apoi vedem ce direcții și pași concreți pot avea sens pentru tine.",
        onContinue: () => startModule5(context),
        onHome: () => goToDashboard(context),
      ),
    ),
  );
}
