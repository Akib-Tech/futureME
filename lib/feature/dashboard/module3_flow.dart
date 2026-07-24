import 'package:flutter/material.dart';
import 'package:futureme/feature/dashboard/module_complete_screen.dart';
import 'package:futureme/feature/dashboard/module_feedback_summary_screen.dart';
import 'package:futureme/feature/dashboard/module_final_feedback_screen.dart';
import 'package:futureme/feature/dashboard/module_introduction_screen.dart';
import 'package:futureme/feature/dashboard/module_roadmap_screen.dart';
import 'package:futureme/feature/dashboard/module_scale_question_screen.dart';

/// Wires the Module 3 screens ("Interese & vocație") into a push-based
/// flow. Module 3 has only 3 stages, and — unlike Module 2 — no per-stage
/// "Complete" screen: each stage goes straight from its last question to
/// its Feedback Summary.
///
/// PLACEHOLDER CONTENT: see the note on Module 2's statement lists — Figma
/// gives item counts (48/30/30) but only one example statement per stage.
const List<String> _stage1PlaceholderStatements = [
  "Îmi place să găsesc explicații pentru cum funcționează lucrurile.",
  "Mă atrag activitățile în care pot crea sau exprima idei.",
  "Îmi place să ajut sau să înțeleg oamenii din jurul meu.",
  "Sunt curioasă să explorez teme și domenii noi.",
  "Prefer activități în care pot analiza și rezolva probleme.",
];

const List<String> _stage2PlaceholderStatements = [
  "Lucrez mai bine când am libertate să aleg cum abordez o sarcină.",
  "Am nevoie de repere clare ca să știu încotro merg.",
  "Prefer un ritm care se adaptează la energia mea.",
  "Colaborez bine când există respect și un scop comun.",
  "Continui mai ușor când înțeleg de ce contează ceea ce fac.",
];

const List<String> _stage3PlaceholderStatements = [
  "Funcționez mai bine în contexte calme, fără presiune constantă.",
  "Am nevoie de un mediu previzibil, în care schimbările sunt explicate.",
  "Prefer oameni respectuoși, fără competiție constantă.",
  "Am nevoie de momente de concentrare fără întreruperi.",
  "Mă simt bine în medii care îmi susțin ritmul propriu.",
];

void startModule3(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleIntroductionScreen(
        moduleLabel: "Modulul 3",
        moduleTitle: "Interese & vocație",
        description:
            "În acest modul explorăm ce tipuri de activități îți stârnesc curiozitatea, cum îți place să lucrezi și în ce medii te-ai simți mai în largul tău.",
        nextSteps: const [
          "3 etape care te ajută să înțelegi ce te atrage",
          "Parcurgi afirmații scurte și alegi cât de mult ți se potrivesc",
          "La final, vezi ce interese ies în evidență, cum îți place să lucrezi și ce medii te susțin",
        ],
        continueLabel: "Vezi pașii modulului",
        progressNote: "Nu trebuie să știi deja ce carieră vrei. Începem să observăm ce pare să aibă sens pentru tine.",
        onContinue: () => _openRoadmap(context),
      ),
    ),
  );
}

void _openRoadmap(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleRoadmapScreen(
        moduleLabel: "Modulul 3",
        title: "Ce descoperim împreună",
        description:
            "În următoarele etape ne uităm la ce îți atrage atenția, cum îți vine mai natural să lucrezi și ce contexte te ajută să te simți în largul tău.",
        steps: const [
          RoadmapStep(
            title: "Ce te atrage",
            description: "Observi ce activități, teme sau domenii îți stârnesc interesul și îți captează atenția.",
          ),
          RoadmapStep(
            title: "Cum îți place să lucrezi",
            description: "Vezi dacă îți este mai ușor să lucrezi cu libertate, cu ghidaj, în ritmul tău sau alături de alții.",
          ),
          RoadmapStep(
            title: "Mediile care te susțin",
            description: "Descoperi ce contexte, ritmuri și tipuri de oameni te ajută să te simți mai în largul tău.",
          ),
        ],
        continueLabel: "Începe prima etapă",
        onContinue: () => _openStage1Intro(context),
      ),
    ),
  );
}

void _openStage1Intro(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleIntroductionScreen(
        moduleLabel: "Etapa 1 din 3 • RIASEC",
        moduleTitle: "Ce te atrage",
        description: "Această etapă te ajută să observi ce tipuri de activități, teme și domenii îți stârnesc interesul.",
        nextSteps: const [
          "48 de afirmații scurte",
          "Alegi cât de mult ți se potrivește fiecare afirmație",
          "La final, vezi ce zone de interes ies mai mult în evidență",
        ],
        continueLabel: "Începe etapa",
        progressNote:
            "Răspunde după cum simți acum. Interesele se pot schimba în timp, iar aici observăm doar ce îți atrage atenția.",
        onContinue: () => _openStage1Question(context, 0),
      ),
    ),
  );
}

void _openStage1Question(BuildContext context, int index) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleScaleQuestionScreen(
        sectionLabel: "Ce te atrage",
        statement: _stage1PlaceholderStatements[index],
        questionNumber: index + 1,
        totalQuestions: _stage1PlaceholderStatements.length,
        onContinue: (selection) {
          if (index + 1 < _stage1PlaceholderStatements.length) {
            _openStage1Question(context, index + 1);
          } else {
            _openStage1Feedback(context);
          }
        },
      ),
    ),
  );
}

void _openStage1Feedback(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleFeedbackSummaryScreen(
        moduleLabel: "Etapa 1 · Feedback scurt",
        title: "Ce pare să te atragă",
        description: "Răspunsurile tale arată ce tipuri de activități și domenii au ieșit mai mult în evidență.",
        profileLabel: "Zone de interes care ies în evidență",
        profileValue: "Creativ, social și investigativ",
        profileDescription: "Par să iasă în evidență activitățile în care poți combina idei, oameni și curiozitate.",
        summaryItems: const [
          SummaryItem(
            icon: Icons.palette_outlined,
            title: "Creativ",
            description: "Îți pot plăcea activitățile în care exprimi idei, creezi sau găsești forme personale de lucru.",
          ),
          SummaryItem(
            icon: Icons.groups_outlined,
            title: "Social",
            description: "Pari să fii atras(ă) de contexte în care poți înțelege, ajuta sau lucra cu oameni.",
          ),
          SummaryItem(
            icon: Icons.search_outlined,
            title: "Investigativ",
            description: "Îți pot plăcea activitățile în care cauți explicații și încerci să înțelegi cum funcționează lucrurile.",
          ),
        ],
        infoNote: "Acesta nu este un verdict despre cariera ta. Este un prim indiciu despre zonele care îți trezesc interesul.",
        continueLabel: "Continuă cu Etapa 2",
        chatLabel: "Discută feedbackul în Chat",
        onContinue: () => _openStage2Intro(context),
        onChat: () => Navigator.popUntil(context, (route) => route.isFirst),
      ),
    ),
  );
}

void _openStage2Intro(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleIntroductionScreen(
        moduleLabel: "Etapa 2 din 3 • Preferințe profesionale",
        moduleTitle: "Cum îți place să lucrezi",
        description:
            "Această etapă te ajută să înțelegi ce ritm, câtă libertate și cât ghidaj te ajută să te implici mai ușor.",
        nextSteps: const [
          "30 de afirmații scurte",
          "Alegi cât de mult ți se potrivește fiecare afirmație",
          "La final, vezi ce stiluri de lucru ies mai mult în evidență",
        ],
        continueLabel: "Începe etapa",
        progressNote: "Nu există un mod corect de a lucra. Observăm ce te ajută să te implici și să te simți în largul tău.",
        onContinue: () => _openStage2Question(context, 0),
      ),
    ),
  );
}

void _openStage2Question(BuildContext context, int index) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleScaleQuestionScreen(
        sectionLabel: "Cum îți place să lucrezi",
        statement: _stage2PlaceholderStatements[index],
        questionNumber: index + 1,
        totalQuestions: _stage2PlaceholderStatements.length,
        onContinue: (selection) {
          if (index + 1 < _stage2PlaceholderStatements.length) {
            _openStage2Question(context, index + 1);
          } else {
            _openStage2Feedback(context);
          }
        },
      ),
    ),
  );
}

void _openStage2Feedback(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleFeedbackSummaryScreen(
        moduleLabel: "Etapa 2 · Feedback scurt",
        title: "Cum îți place să lucrezi",
        description: "Răspunsurile tale arată ce ritm, câtă libertate și ce fel de sprijin par să te ajute să lucrezi mai natural.",
        profileLabel: "Stil de lucru care iese în evidență",
        profileValue: "Libertate cu repere clare",
        profileDescription:
            "Pari să lucrezi mai bine când ai spațiu să alegi cum abordezi o sarcină, dar și repere clare care te ajută să știi încotro mergi.",
        summaryItems: const [
          SummaryItem(
            icon: Icons.explore_outlined,
            title: "Libertate și repere",
            description: "Pari să ai nevoie de spațiu să alegi cum abordezi o sarcină, dar și de repere clare ca să știi încotro mergi.",
          ),
          SummaryItem(
            icon: Icons.speed_outlined,
            title: "Ritmul tău",
            description: "Poți funcționa bine când ritmul se adaptează la tipul de sarcină și la energia ta.",
          ),
          SummaryItem(
            icon: Icons.handshake_outlined,
            title: "Colaborare",
            description: "Poți lucra bine cu alții atunci când există respect, ascultare și un scop comun.",
          ),
          SummaryItem(
            icon: Icons.flag_outlined,
            title: "Ce te ține implicat(ă)",
            description:
                "Îți poate fi mai ușor să continui când înțelegi de ce contează ceea ce faci și primești semne că mergi în direcția bună.",
          ),
        ],
        infoNote:
            "Nu există un singur mod bun de a lucra. Acest feedback arată doar ce condiții par să te ajute să te implici mai natural.",
        continueLabel: "Continuă cu Etapa 3",
        chatLabel: "Discută feedbackul în Chat",
        onContinue: () => _openStage3Intro(context),
        onChat: () => Navigator.popUntil(context, (route) => route.isFirst),
      ),
    ),
  );
}

void _openStage3Intro(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleIntroductionScreen(
        moduleLabel: "Etapa 3 din 3 • Medii de lucru",
        moduleTitle: "Mediile care te susțin",
        description:
            "Această etapă te ajută să observi în ce contexte și ritmuri te simți mai în largul tău când înveți, lucrezi sau explorezi ceva nou",
        nextSteps: const [
          "30 de afirmații scurte",
          "Alegi cât de mult ți se potrivește fiecare afirmație",
          "La final, vezi ce fel de medii par să te susțină mai bine",
        ],
        continueLabel: "Începe etapa",
        progressNote: "Nu căutăm un mediu perfect. Observăm ce condiții te ajută să te simți mai în largul tău.",
        onContinue: () => _openStage3Question(context, 0),
      ),
    ),
  );
}

void _openStage3Question(BuildContext context, int index) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleScaleQuestionScreen(
        sectionLabel: "Mediile care te susțin",
        statement: _stage3PlaceholderStatements[index],
        questionNumber: index + 1,
        totalQuestions: _stage3PlaceholderStatements.length,
        onContinue: (selection) {
          if (index + 1 < _stage3PlaceholderStatements.length) {
            _openStage3Question(context, index + 1);
          } else {
            _openStage3Feedback(context);
          }
        },
      ),
    ),
  );
}

void _openStage3Feedback(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleFeedbackSummaryScreen(
        moduleLabel: "Etapa 3 · Feedback scurt",
        title: "Mediile care te susțin",
        description: "Răspunsurile tale arată ce tipuri de contexte par să îți ofere mai multă claritate, liniște și energie.",
        profileLabel: "Medii care ies în evidență",
        profileValue: "Calm și susținător",
        profileDescription:
            "Pari să funcționezi mai bine în contexte așezate, cu presiune redusă, oameni respectuoși și spațiu să lucrezi în ritmul tău.",
        summaryItems: const [
          SummaryItem(
            icon: Icons.spa_outlined,
            title: "Ritm și presiune",
            description: "Pari să ai nevoie de un mediu în care lucrurile nu se simt mereu grăbite sau apăsătoare.",
          ),
          SummaryItem(
            icon: Icons.balance_outlined,
            title: "Stabilitate și schimbare",
            description: "Te poate ajuta un context suficient de previzibil, în care schimbările sunt explicate și nu apar haotic.",
          ),
          SummaryItem(
            icon: Icons.diversity_3_outlined,
            title: "Oameni și atmosferă",
            description: "Poți funcționa mai bine când există respect, ascultare și colaborare, fără comparație sau competiție constantă.",
          ),
          SummaryItem(
            icon: Icons.center_focus_strong_outlined,
            title: "Spațiu pentru concentrare",
            description: "Îți poate fi mai ușor să lucrezi când ai momente în care te poți concentra fără prea multe întreruperi.",
          ),
        ],
        infoNote: "Nu ai nevoie de un mediu perfect ca să îți fie bine. Acest feedback arată ce condiții par să te susțină mai mult.",
        continueLabel: "Vezi imaginea de ansamblu",
        chatLabel: "Discută feedbackul în Chat",
        onContinue: () => _openFinalFeedback(context),
        onChat: () => Navigator.popUntil(context, (route) => route.isFirst),
      ),
    ),
  );
}

void _openFinalFeedback(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleFinalFeedbackScreen(
        moduleLabel: "Modulul 3 · Imagine de ansamblu",
        title: "Ce ai descoperit în Modulul 3",
        description:
            "Răspunsurile tale arată că nu contează doar domeniul, ci și felul în care lucrezi și mediul în care te simți în largul tău.",
        synthesisTitle: "Ce iese în evidență",
        synthesisDescription:
            "Par să merite explorate direcții în care poți lucra cu idei, oameni și sens. Îți poate fi mai ușor când ai spațiu să gândești, dar și repere clare ca să știi încotro mergi.",
        connectionsTitle: "Ce ai aflat despre tine",
        connections: const [
          ConnectionItem(
            icon: Icons.favorite_border,
            title: "Ce te atrage",
            description: "Activități în care poți crea, explica, analiza sau înțelege mai bine oamenii și ideile.",
          ),
          ConnectionItem(
            icon: Icons.build_outlined,
            title: "Cum îți place să lucrezi",
            description: "Cu libertate în felul în care abordezi lucrurile, dar și cu direcție, claritate și un ritm pe care îl poți susține.",
          ),
          ConnectionItem(
            icon: Icons.home_outlined,
            title: "Mediile care te susțin",
            description: "Mediile calme, respectuoase, cu presiune redusă și spațiu pentru concentrare.",
          ),
        ],
        explorationTitle: "Arii care merită explorate",
        explorationItems: const [
          "Comunicare & creație",
          "Oameni & sprijin",
          "Analiză & înțelegere",
        ],
        infoNote:
            "Nu alegem încă o carieră finală. Aceste direcții sunt repere de explorare, iar în Modulul 4 vedem ce puncte forte le pot susține.",
        continueLabel: "Ascultă mesajul pentru tine",
        chatLabel: "Discută Modulul 3 în Chat",
        onContinue: () => _openModule3Complete(context),
        onChat: () => Navigator.popUntil(context, (route) => route.isFirst),
      ),
    ),
  );
}

void _openModule3Complete(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleCompleteScreen(
        title: "Modulul 3 este complet",
        message:
            "Ai explorat ce te atrage, cum îți place să lucrezi și ce medii te pot susține. Înainte să mergi mai departe, ia-ți un moment de pauză.",
        encouragementNote: "Nu trebuie să alegi o direcție finală acum. Lasă lucrurile să se așeze puțin.",
        continueLabel: "Continuă cu Modulul 4",
        nextModuleLabel: "Urmează Modulul 4",
        nextModuleTitle: "Aptitudini & puncte forte",
        nextModuleDescription:
            "Vei vedea ce îți vine mai natural, ce poți dezvolta și ce puncte forte pot susține direcțiile conturate în Modulul 3.",
        // Module 4 isn't implemented yet — return to the dashboard for now.
        onContinue: () => Navigator.popUntil(context, (route) => route.isFirst),
        onHome: () => Navigator.popUntil(context, (route) => route.isFirst),
      ),
    ),
  );
}
