import 'package:flutter/material.dart';
import 'package:futureme/feature/dashboard/module_complete_screen.dart';
import 'package:futureme/feature/dashboard/module_feedback_summary_screen.dart';
import 'package:futureme/feature/dashboard/module_final_feedback_screen.dart';
import 'package:futureme/feature/dashboard/module_introduction_screen.dart';
import 'package:futureme/feature/dashboard/module_mbti_question_screen.dart';
import 'package:futureme/feature/dashboard/module_roadmap_screen.dart';
import 'package:futureme/feature/dashboard/module_scale_question_screen.dart';
import 'package:futureme/feature/dashboard/module3_flow.dart';
import 'package:futureme/feature/dashboard/stage_complete_screen.dart';

/// Wires the Module 2 screens into a push-based flow. Currently covers
/// Stage 1 only (Figma frames 94:600, 130:620, 147:1239 template,
/// 138:950, 140:1073) as the template for Stages 2-6.
///
/// PLACEHOLDER CONTENT: Figma's Stage 1 design says "32 de perechi de
/// afirmații" but only ever shows one example pair — the real 32-item MBTI
/// question bank isn't part of the design file. The list below is a small
/// stand-in (5 pairs) so the flow is navigable end-to-end; replace with the
/// real question bank when available.
const List<(String, String)> _stage1PlaceholderStatements = [
  (
    "Îmi iau energia din timpul petrecut cu alți oameni.",
    "Îmi încarc energia mai ales când am timp pentru mine.",
  ),
  (
    "Prefer să discut o idee cu voce tare, pe măsură ce mă gândesc la ea.",
    "Prefer să mă gândesc bine la o idee înainte să o spun.",
  ),
  (
    "Mă bazez mai mult pe fapte și detalii concrete.",
    "Mă bazez mai mult pe intuiție și posibilități.",
  ),
  (
    "Iau decizii mai ales pe baza logicii.",
    "Iau decizii ținând cont mai ales de oameni și context.",
  ),
  (
    "Prefer un plan clar și stabilit din timp.",
    "Prefer să rămân flexibil și să decid pe parcurs.",
  ),
];

/// PLACEHOLDER CONTENT: Stage 2 says "50 de afirmații scurte" in Figma but,
/// like Stage 1, only shows one example. Small stand-in list below.
const List<String> _stage2PlaceholderStatements = [
  "Îmi place să explorez idei și perspective noi.",
  "Prefer să am un plan clar înainte să încep ceva.",
  "Mă simt energizată în compania altor oameni.",
  "Pun preț pe armonie și pe cum se simt cei din jur.",
  "Rămân calmă chiar și în situații stresante.",
];

/// PLACEHOLDER CONTENT — see note on [_stage1PlaceholderStatements].
const List<String> _stage3PlaceholderStatements = [
  "Prefer să înțeleg imaginea de ansamblu înainte de detalii.",
  "Analizez lucrurile pas cu pas, logic.",
  "Îmi place să leg ideile de exemple concrete.",
  "Am nevoie de timp să reflectez înainte să răspund.",
  "Lucrez mai bine când am pași clari de urmat.",
];

/// PLACEHOLDER CONTENT — see note on [_stage1PlaceholderStatements].
const List<String> _stage4PlaceholderStatements = [
  "Prefer să analizez toate opțiunile înainte să aleg.",
  "Uneori aleg pe baza intuiției, nu doar a logicii.",
  "Îmi place să cer părerea altora înainte de o decizie importantă.",
  "Prefer să iau decizii în ritmul meu, fără grabă.",
  "Amân o decizie când nu mă simt pregătită.",
];

/// PLACEHOLDER CONTENT — see note on [_stage1PlaceholderStatements].
const List<String> _stage5PlaceholderStatements = [
  "Simt presiune când am multe lucruri de făcut deodată.",
  "Mă îndoiesc de mine când trebuie să aleg repede.",
  "Îmi este greu să fiu blândă cu mine când ceva nu iese bine.",
  "Am nevoie de timp și liniște ca să îmi revin.",
  "Sub presiune, îmi este greu să văd clar.",
];

/// PLACEHOLDER CONTENT — see note on [_stage1PlaceholderStatements].
const List<String> _stage6PlaceholderStatements = [
  "Simt că alegerile mele pot schimba lucrurile în timp.",
  "Cred că unele rezultate depind mai mult de context decât de mine.",
  "Îmi este mai ușor când știu exact ce pas depinde de mine.",
  "Cer ajutor când simt că ceva nu ține doar de mine.",
  "Mă simt mai calmă când nu încerc să controlez totul.",
];

void startModule2(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleIntroductionScreen(
        moduleLabel: "Modulul 2",
        moduleTitle: "Profil psihologic",
        description: "În acest modul explorăm cum gândești, iei decizii și reacționezi în situații diferite.",
        nextSteps: const [
          "Etape scurte, parcurse pe rând",
          "Răspunsuri sincere, nu perfecte",
          "Feedback scurt după fiecare etapă",
        ],
        continueLabel: "Vezi pașii modulului",
        progressNote: "Nu trebuie să termini totul dintr-o dată. Progresul tău este salvat.",
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
        moduleLabel: "Modulul 2",
        title: "Ce explorăm împreună",
        description: "Fiecare etapă adaugă o piesă nouă despre tine. Le parcurgem pe rând, fără presiune.",
        steps: const [
          RoadmapStep(
            title: "Cine ești și cum funcționezi",
            description: "Cum te raportezi la oameni, informații și alegeri.",
          ),
          RoadmapStep(
            title: "Cum funcționează personalitatea ta",
            description: "Cum lucrezi, comunici și reacționezi la schimbare.",
          ),
          RoadmapStep(
            title: "Cum gândești",
            description: "Cum înveți, observi și rezolvi probleme.",
          ),
          RoadmapStep(
            title: "Cum faci alegeri",
            description: "Ce te ajută sau te încurcă atunci când iei decizii.",
          ),
          RoadmapStep(
            title: "Cum reacționezi sub presiune",
            description: "Ce se întâmplă când apare stresul sau îndoiala.",
          ),
          RoadmapStep(
            title: "Cât control simți că ai",
            description: "Cum simți că poți influența ce urmează.",
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
        moduleLabel: "Etapa 1 din 6 · MBTI",
        moduleTitle: "Cine ești și cum funcționezi",
        description: "Această etapă te ajută să observi cum te raportezi la oameni și la alegerile pe care le faci.",
        nextSteps: const [
          "32 de perechi de afirmații",
          "Împarți 5 puncte între cele două variante",
          "Alegi proporția care se simte cea mai apropiată de tine",
        ],
        continueLabel: "Începe etapa",
        progressNote: "Alege cum se împart cele 5 puncte în funcție de cât de mult te regăsești în fiecare variantă.",
        onContinue: () => _openStage1Question(context, 0),
      ),
    ),
  );
}

void _openStage1Question(BuildContext context, int index) {
  final (statementA, statementB) = _stage1PlaceholderStatements[index];
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleMbtiQuestionScreen(
        sectionLabel: "Cine ești și cum funcționezi",
        statementA: statementA,
        statementB: statementB,
        questionNumber: index + 1,
        totalQuestions: _stage1PlaceholderStatements.length,
        onContinue: (pointsForA, pointsForB) {
          if (index + 1 < _stage1PlaceholderStatements.length) {
            _openStage1Question(context, index + 1);
          } else {
            _openStage1Complete(context);
          }
        },
      ),
    ),
  );
}

void _openStage1Complete(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => StageCompleteScreen(
        stageLabel: "Modulul 2 · Etapa 1 din 6",
        title: "Etapa 1 este completă",
        message:
            "Ai parcurs prima etapă a profilului tău. Răspunsurile tale rămân aici, iar în continuare le privim ca prime repere, nu ca o concluzie.",
        achievementTitle: "Cine ești și cum funcționezi",
        achievementSubtitle: "32 de afirmații finalizate",
        infoNote: "Nu tragem concluzii încă. E doar primul pas. Profilul tău se construiește treptat.",
        primaryLabel: "Vezi feedbackul",
        onPrimary: () => _openStage1Feedback(context),
        secondaryLabel: "Revin mai târziu",
        onSecondary: () => Navigator.popUntil(context, (route) => route.isFirst),
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
        title: "Profilul tău începe să se contureze",
        description:
            "Pe baza răspunsurilor tale, apar primele repere despre cum te raportezi la oameni, informații și decizii.",
        profileLabel: "Profil orientativ",
        profileValue: "INFJ",
        profileDescription:
            "Răspunsurile tale sugerează un stil atent, orientat spre sens și conectat la ceea ce este important pentru tine.",
        summaryItems: const [
          SummaryItem(
            icon: Icons.bolt_outlined,
            title: "Energie",
            description: "Pari să îți încarci energia în spații mai calme sau alături de oameni apropiați.",
          ),
          SummaryItem(
            icon: Icons.lightbulb_outline,
            title: "Informații",
            description: "Îți poate fi mai natural să cauți sensul din spatele detaliilor.",
          ),
          SummaryItem(
            icon: Icons.balance_outlined,
            title: "Decizii",
            description: "Când iei decizii, pari să ții cont atât de ce simți tu, cât și de impactul asupra celorlalți.",
          ),
        ],
        infoNote: "Acesta este un reper, nu o etichetă. Următoarele etape vor adăuga context.",
        continueLabel: "Continuă cu Personalitatea ta",
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
        moduleLabel: "Etapa 2 din 6 · Big Five / OCEAN",
        moduleTitle: "Personalitatea ta",
        description:
            "Aici observi cum se conturează personalitatea ta: relația cu ideile noi, nevoia de structură, felul în care te simți cu oamenii și cum reacționezi la stres.",
        nextSteps: const [
          "50 de afirmații scurte",
          "Alegi cât de adevărată se simte fiecare afirmație",
          "Înțelegi cum lucrezi, relaționezi și reacționezi la stres",
        ],
        continueLabel: "Începe etapa",
        progressNote: "Răspunde sincer, nu cum crezi că „ar trebui”.",
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
        sectionLabel: "Personalitatea ta",
        statement: _stage2PlaceholderStatements[index],
        questionNumber: index + 1,
        totalQuestions: _stage2PlaceholderStatements.length,
        onContinue: (selection) {
          if (index + 1 < _stage2PlaceholderStatements.length) {
            _openStage2Question(context, index + 1);
          } else {
            _openStage2Complete(context);
          }
        },
      ),
    ),
  );
}

void _openStage2Complete(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => StageCompleteScreen(
        stageLabel: "Modulul 2 · Etapa 2 din 6",
        title: "Etapa 2 este completă",
        message:
            "Ai parcurs etapa despre personalitatea ta. Răspunsurile tale încep să așeze câteva repere, iar în continuare le privim fără concluzii fixe.",
        achievementTitle: "Personalitatea ta",
        achievementSubtitle: "50 de afirmații finalizate",
        infoNote: "Nu trebuie să te recunoști perfect în fiecare reper. Căutăm direcții, nu definiții.",
        primaryLabel: "Vezi feedbackul",
        onPrimary: () => _openStage2Feedback(context),
        secondaryLabel: "Revin mai târziu",
        onSecondary: () => Navigator.popUntil(context, (route) => route.isFirst),
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
        title: "O privire asupra personalității tale",
        description:
            "Cele 5 dimensiuni te ajută să vezi cum îți iei energia, cum lucrezi, cum relaționezi și cum gestionezi schimbarea sau stresul.",
        summaryItems: const [
          SummaryItem(
            icon: Icons.explore_outlined,
            title: "Curiozitate",
            description: "Pari atrasă de idei noi, perspective diferite și contexte în care poți explora.",
            level: SummaryLevel.high,
          ),
          SummaryItem(
            icon: Icons.checklist_outlined,
            title: "Organizare",
            description: "Îți poate fi mai ușor să funcționezi când ai structură, pași clari și obiective definite.",
            level: SummaryLevel.medium,
          ),
          SummaryItem(
            icon: Icons.bolt_outlined,
            title: "Energie socială",
            description: "Pari să îți încarci energia mai ales în spații calme sau alături de oameni apropiați.",
            level: SummaryLevel.low,
          ),
          SummaryItem(
            icon: Icons.handshake_outlined,
            title: "Relaționare",
            description: "Pari să pui preț pe cooperare, armonie și pe felul în care se simt cei din jur.",
            level: SummaryLevel.high,
          ),
          SummaryItem(
            icon: Icons.self_improvement_outlined,
            title: "Echilibru emoțional",
            description: "În perioade încărcate, poate fi util să îți acorzi timp ca să îți recapeți echilibrul.",
            level: SummaryLevel.medium,
          ),
        ],
        infoNote: "Aceste repere nu te definesc complet. Următoarele etape vor adăuga context.",
        continueLabel: "Continuă cu Stilul cognitiv",
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
        moduleLabel: "Etapa 3 din 6 · Stil cognitiv",
        moduleTitle: "Cum gândești",
        description: "Această etapă te ajută să observi cum înveți, analizezi informațiile și găsești soluții.",
        nextSteps: const [
          "25 de afirmații scurte",
          "Alegi cât de mult te regăsești în fiecare",
          "Afli ce îți vine natural când înveți și cauți soluții",
        ],
        continueLabel: "Începe etapa",
        progressNote: "Nu măsurăm inteligența. Explorăm felul în care mintea ta funcționează cel mai natural.",
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
        sectionLabel: "Cum gândești",
        statement: _stage3PlaceholderStatements[index],
        questionNumber: index + 1,
        totalQuestions: _stage3PlaceholderStatements.length,
        onContinue: (selection) {
          if (index + 1 < _stage3PlaceholderStatements.length) {
            _openStage3Question(context, index + 1);
          } else {
            _openStage3Complete(context);
          }
        },
      ),
    ),
  );
}

void _openStage3Complete(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => StageCompleteScreen(
        stageLabel: "Modulul 2 · Etapa 3 din 6",
        title: "Etapa 3 este completă",
        message:
            "Ai parcurs etapa despre felul în care gândești. Răspunsurile tale ne ajută să observăm un stil, nu să măsurăm cât de „bine” gândești.",
        achievementTitle: "Cum gândești",
        achievementSubtitle: "25 de afirmații finalizate",
        infoNote: "Nu măsurăm cât de bine gândești. Observăm cum îți vine mai natural să înțelegi lucrurile.",
        primaryLabel: "Vezi feedbackul",
        onPrimary: () => _openStage3Feedback(context),
        secondaryLabel: "Revin mai târziu",
        onSecondary: () => Navigator.popUntil(context, (route) => route.isFirst),
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
        title: "Stilul tău de gândire începe să se clarifice",
        description: "Răspunsurile tale arată câteva indicii despre cum înveți, analizezi și abordezi problemele.",
        summaryItems: const [
          SummaryItem(
            icon: Icons.visibility_outlined,
            title: "Perspectiva ta",
            description: "Pari să cauți sensul general înainte să intri în detalii.",
            badgeLabel: "Ansamblu",
          ),
          SummaryItem(
            icon: Icons.psychology_outlined,
            title: "Cum analizezi",
            description: "Îți poate fi util să înțelegi logica din spatele unei situații înainte să alegi.",
            badgeLabel: "Analitic",
          ),
          SummaryItem(
            icon: Icons.handyman_outlined,
            title: "Aplicare practică",
            description: "Poți avea nevoie să vezi cum se leagă ideile de situații concrete.",
            badgeLabel: "Mixt",
          ),
          SummaryItem(
            icon: Icons.hourglass_empty_outlined,
            title: "Ritmul tău",
            description: "Pari să preferi puțin timp pentru a așeza informațiile înainte să răspunzi.",
            badgeLabel: "Reflectiv",
          ),
          SummaryItem(
            icon: Icons.grid_view_outlined,
            title: "Structură",
            description: "Îți poate fi mai ușor să lucrezi când ai pași clari și repere stabile.",
            badgeLabel: "Structurat",
          ),
        ],
        infoNote: "Acest feedback descrie un stil, nu o măsură a inteligenței. Următoarele etape vor adăuga context.",
        continueLabel: "Continuă cu Stilul decizional",
        chatLabel: "Discută feedbackul în Chat",
        onContinue: () => _openStage4Intro(context),
        onChat: () => Navigator.popUntil(context, (route) => route.isFirst),
      ),
    ),
  );
}

void _openStage4Intro(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleIntroductionScreen(
        moduleLabel: "Etapa 4 din 6 · Stil decizional",
        moduleTitle: "Cum alegi",
        description:
            "Această etapă te ajută să observi ce se întâmplă în tine atunci când ai de luat o decizie: ce îți aduce claritate, ce te face să eziți și ce fel de sprijin îți poate face alegerea mai ușoară.",
        nextSteps: const [
          "20 de afirmații scurte",
          "Alegi ce se potrivește felului tău de a decide",
          "Înțelegi ce contează pentru tine când faci alegeri",
        ],
        continueLabel: "Începe etapa",
        progressNote: "Nu trebuie să alegi perfect. Doar observăm ce te ajută să alegi mai clar.",
        onContinue: () => _openStage4Question(context, 0),
      ),
    ),
  );
}

void _openStage4Question(BuildContext context, int index) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleScaleQuestionScreen(
        sectionLabel: "Cum alegi",
        statement: _stage4PlaceholderStatements[index],
        questionNumber: index + 1,
        totalQuestions: _stage4PlaceholderStatements.length,
        onContinue: (selection) {
          if (index + 1 < _stage4PlaceholderStatements.length) {
            _openStage4Question(context, index + 1);
          } else {
            _openStage4Complete(context);
          }
        },
      ),
    ),
  );
}

void _openStage4Complete(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => StageCompleteScreen(
        stageLabel: "Modulul 2 · Etapa 4 din 6",
        title: "Etapa 4 este completă",
        message:
            "Ai parcurs etapa despre felul în care iei decizii. Răspunsurile tale ne ajută să vedem ce te poate susține când ai de ales.",
        achievementTitle: "Cum alegi",
        achievementSubtitle: "20 de afirmații finalizate",
        infoNote: "Stilul tău decizional nu te limitează. Îți arată ce te poate ajuta să alegi mai clar.",
        primaryLabel: "Vezi feedbackul",
        onPrimary: () => _openStage4Feedback(context),
        secondaryLabel: "Revin mai târziu",
        onSecondary: () => Navigator.popUntil(context, (route) => route.isFirst),
      ),
    ),
  );
}

void _openStage4Feedback(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleFeedbackSummaryScreen(
        moduleLabel: "Etapa 4 · Feedback scurt",
        title: "Stilul tău decizional se conturează",
        description: "Răspunsurile tale sugerează ce stil apare mai des atunci când ai de luat o decizie.",
        profileLabel: "Stil decizional orientativ",
        profileValue: "Analitic",
        profileDescription:
            "Alegi mai ușor când ai timp să înțelegi opțiunile, să compari argumentele și să vezi clar consecințele.",
        summaryItems: const [
          SummaryItem(
            icon: Icons.query_stats_outlined,
            title: "Analiză",
            description: "Tinzi să cântărești opțiunile și să cauți argumente clare înainte să alegi.",
          ),
          SummaryItem(
            icon: Icons.auto_awesome_outlined,
            title: "Intuiție",
            description: "Uneori contează și ce simți că este potrivit, dar nu pare să fie singurul criteriu.",
          ),
          SummaryItem(
            icon: Icons.groups_outlined,
            title: "Sprijin",
            description: "Poți lua în calcul părerea celor din jur, mai ales când decizia contează.",
          ),
          SummaryItem(
            icon: Icons.hourglass_empty_outlined,
            title: "Ritmul tău",
            description: "Pari să preferi un ritm mai așezat, în care decizia are timp să devină clară.",
          ),
          SummaryItem(
            icon: Icons.pause_circle_outlined,
            title: "Amânare",
            description: "Nu apare ca tendință principală, dar poate apărea când o alegere se simte apăsătoare.",
          ),
        ],
        infoNote: "Acest feedback descrie un stil, nu o etichetă fixă. Următoarea etapă va adăuga context emoțional.",
        continueLabel: "Continuă cu Tiparele emoționale",
        chatLabel: "Discută feedbackul în Chat",
        onContinue: () => _openStage5Intro(context),
        onChat: () => Navigator.popUntil(context, (route) => route.isFirst),
      ),
    ),
  );
}

void _openStage5Intro(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleIntroductionScreen(
        moduleLabel: "Etapa 5 din 6 • Tipare emoționale",
        moduleTitle: "Cum reacționezi sub presiune",
        description: "Această etapă te ajută să observi cum reacționezi în situații solicitante.",
        nextSteps: const [
          "30 de afirmații scurte",
          "Alegi cât de adevărată se simte fiecare afirmație pentru tine",
          "Înțelegi ce se întâmplă cu tine în momente solicitante",
        ],
        continueLabel: "Începe etapa",
        progressNote: "Emoțiile tale nu sunt ceva de reparat. Sunt semnale care te ajută să înțelegi ce ai nevoie.",
        onContinue: () => _openStage5Question(context, 0),
      ),
    ),
  );
}

void _openStage5Question(BuildContext context, int index) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleScaleQuestionScreen(
        sectionLabel: "Cum reacționezi sub presiune",
        statement: _stage5PlaceholderStatements[index],
        questionNumber: index + 1,
        totalQuestions: _stage5PlaceholderStatements.length,
        onContinue: (selection) {
          if (index + 1 < _stage5PlaceholderStatements.length) {
            _openStage5Question(context, index + 1);
          } else {
            _openStage5Complete(context);
          }
        },
      ),
    ),
  );
}

void _openStage5Complete(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => StageCompleteScreen(
        stageLabel: "Modulul 2 · Etapa 5 din 6",
        title: "Etapa 5 este completă",
        message:
            "Ai parcurs o etapă mai sensibilă. Răspunsurile tale au fost salvate, iar în continuare le privim cu grijă, fără concluzii grăbite.",
        achievementTitle: "Cum reacționezi sub presiune",
        achievementSubtitle: "30 de afirmații finalizate",
        infoNote: "Nu trebuie să tragi concluzii singur(ă). Le luăm pe rând, cu calm.",
        primaryLabel: "Vezi feedbackul",
        onPrimary: () => _openStage5Feedback(context),
        secondaryLabel: "Revin mai târziu",
        onSecondary: () => Navigator.popUntil(context, (route) => route.isFirst),
      ),
    ),
  );
}

void _openStage5Feedback(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleFeedbackSummaryScreen(
        moduleLabel: "Etapa 5 · Feedback scurt",
        title: "Cum reacționezi în momente solicitante",
        description:
            "Răspunsurile tale sugerează câteva repere despre ce te poate tensiona, ce îți poate scădea claritatea și ce te ajută să îți revii.",
        summaryItems: const [
          SummaryItem(
            icon: Icons.layers_outlined,
            title: "Când se adună prea multe",
            description: "Poți simți presiunea mai puternic atunci când sunt multe lucruri de dus sau când nu e clar ce urmează.",
          ),
          SummaryItem(
            icon: Icons.help_outline,
            title: "Încrederea în tine",
            description: "În unele momente, îndoiala poate apărea mai ușor, mai ales când simți că trebuie să alegi bine din prima.",
          ),
          SummaryItem(
            icon: Icons.sentiment_dissatisfied_outlined,
            title: "Când ceva nu iese cum ai vrut",
            description: "Poate fi mai greu să rămâi blând(ă) cu tine atunci când rezultatul nu iese cum sperai.",
          ),
          SummaryItem(
            icon: Icons.favorite_outline,
            title: "Ce te ajută",
            description:
                "Pentru tine, lucrurile pot deveni mai ușor de dus când ai timp, claritate și un spațiu în care nu te simți judecat(ă).",
          ),
          SummaryItem(
            icon: Icons.bolt_outlined,
            title: "Sub presiune",
            description: "Presiunea nu pare să te ajute mereu să vezi lucrurile mai clar. Uneori, ai nevoie mai întâi să te oprești puțin.",
          ),
        ],
        infoNote: "Acesta nu este un verdict despre tine. Este doar o imagine a felului în care reacționezi acum, în anumite momente.",
        continueLabel: "Continuă cu Controlul perceput",
        chatLabel: "Discută feedbackul în Chat",
        onContinue: () => _openStage6Intro(context),
        onChat: () => Navigator.popUntil(context, (route) => route.isFirst),
      ),
    ),
  );
}

void _openStage6Intro(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleIntroductionScreen(
        moduleLabel: "Etapa 6 din 6 · Control perceput",
        moduleTitle: "Ce simți că poți influența",
        description:
            "Această etapă te ajută să observi ce simți că depinde de tine, ce ține de context și unde ai nevoie de mai mult sprijin.",
        nextSteps: const [
          "20 de afirmații scurte",
          "Alegi cât de adevărată se simte fiecare afirmație",
          "Înțelegi ce îți poate da mai multă încredere",
        ],
        continueLabel: "Începe etapa",
        progressNote:
            "Nu trebuie să controlezi totul ca să mergi mai departe. Uneori, claritatea începe cu lucrurile mici pe care le poți alege azi.",
        onContinue: () => _openStage6Question(context, 0),
      ),
    ),
  );
}

void _openStage6Question(BuildContext context, int index) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleScaleQuestionScreen(
        sectionLabel: "Ce simți că poți influența",
        statement: _stage6PlaceholderStatements[index],
        questionNumber: index + 1,
        totalQuestions: _stage6PlaceholderStatements.length,
        onContinue: (selection) {
          if (index + 1 < _stage6PlaceholderStatements.length) {
            _openStage6Question(context, index + 1);
          } else {
            _openStage6Complete(context);
          }
        },
      ),
    ),
  );
}

void _openStage6Complete(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => StageCompleteScreen(
        stageLabel: "Modulul 2 · Etapa 6 din 6",
        title: "Etapa 6 este completă",
        message:
            "Ai parcurs ultima etapă a profilului psihologic. Răspunsurile tale ne ajută să vedem cum se leagă piesele între ele.",
        achievementTitle: "Ce simți că poți influența",
        achievementSubtitle: "20 de afirmații finalizate",
        infoNote: "Ai ajuns la ultima piesă din acest modul. În curând le vom pune pe toate cap la cap.",
        primaryLabel: "Vezi feedbackul",
        onPrimary: () => _openStage6Feedback(context),
        secondaryLabel: "Revin mai târziu",
        onSecondary: () => Navigator.popUntil(context, (route) => route.isFirst),
      ),
    ),
  );
}

void _openStage6Feedback(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleFeedbackSummaryScreen(
        moduleLabel: "Etapa 6 · Feedback scurt",
        title: "Ce simți că poți influența",
        description:
            "Răspunsurile tale arată cum vezi lucrurile din jurul tău: ce simți că poți schimba prin alegerile tale și ce pare să depindă mai mult de context.",
        profileLabel: "Profil orientativ",
        profileValue: "Echilibru realist",
        profileDescription:
            "Pari să vezi că alegerile tale pot conta, chiar dacă unele lucruri țin și de context. Te poate ajuta să observi ce pas concret depinde de tine acum, fără să simți că trebuie să controlezi totul.",
        summaryItems: const [
          SummaryItem(
            icon: Icons.trending_up_outlined,
            title: "Ce ține de tine",
            description: "În multe situații, pașii mici pot conta mai mult decât pare la început. O alegere repetată în timp poate schimba direcția.",
          ),
          SummaryItem(
            icon: Icons.public_outlined,
            title: "Ce nu ține doar de tine",
            description:
                "Unele lucruri au nevoie de timp, sprijin sau un context mai potrivit. Asta nu înseamnă că nu poți face nimic, ci că nu totul se rezolvă doar prin voință.",
          ),
          SummaryItem(
            icon: Icons.handshake_outlined,
            title: "Ce te ajută",
            description: "Te poate ajuta să separi lucrurile simplu: ce poți face acum, unde poți cere sprijin și ce poate aștepta.",
          ),
        ],
        infoNote: "Nu trebuie să controlezi tot drumul. Uneori e suficient să vezi următorul pas care depinde de tine.",
        continueLabel: "Vezi ce ai conturat în Modulul 2",
        chatLabel: "Discută feedbackul în Chat",
        onContinue: () => _openModule2FinalFeedback(context),
        onChat: () => Navigator.popUntil(context, (route) => route.isFirst),
      ),
    ),
  );
}

void _openModule2FinalFeedback(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleFinalFeedbackScreen(
        moduleLabel: "Modulul 2 · Imagine de ansamblu",
        title: "Ce ai înțeles despre tine în Modulul 2",
        description:
            "Cele 6 etape au privit lucrurile din unghiuri diferite. Împreună, ele arată cum gândești, cum alegi și ce ai nevoie ca să vezi mai clar direcția ta.",
        synthesisTitle: "Ce se conturează când le privim împreună",
        synthesisDescription:
            "Se conturează un mod atent de a privi lucrurile, orientat spre sens și claritate. Pari să ai nevoie ca alegerile să aibă logică pentru tine, nu doar să pară corecte din exterior.",
        connectionsTitle: "Cum se leagă între ele",
        connections: const [
          ConnectionItem(
            icon: Icons.lightbulb_outline,
            title: "Când înțelegi sensul",
            description: "Te poți implica mai ușor când vezi de ce contează o alegere pentru tine și cum se leagă de ce îți dorești.",
          ),
          ConnectionItem(
            icon: Icons.compress_outlined,
            title: "Când presiunea crește",
            description: "Poți avea nevoie de timp, repere și claritate ca să alegi cu mai multă încredere.",
          ),
          ConnectionItem(
            icon: Icons.arrow_forward_outlined,
            title: "Când vezi următorul pas",
            description: "Nu trebuie să controlezi totul ca să mergi mai departe. Uneori ajută să vezi ce pas mic depinde de tine acum.",
          ),
        ],
        infoNote: "Aceste repere ne ajută, în următoarele module, să legăm felul în care funcționezi de interesele, aptitudinile și direcțiile potrivite pentru tine.",
        continueLabel: "Ascultă mesajul pentru tine",
        chatLabel: "Discută Modulul 2 în Chat",
        onContinue: () => _openModule2Complete(context),
        onChat: () => Navigator.popUntil(context, (route) => route.isFirst),
      ),
    ),
  );
}

void _openModule2Complete(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleCompleteScreen(
        title: "Modulul 2 este complet",
        message:
            "Ai parcurs un modul intens. Înainte să trecem mai departe, ți-am pregătit un scurt mesaj care pune lucrurile în perspectivă, cu calm.",
        encouragementNote: "Nu trebuie să tragi concluzii acum. E suficient să lași lucrurile să se așeze puțin.",
        continueLabel: "Continuă cu Modulul 3",
        nextModuleLabel: "Urmează Modulul 3",
        nextModuleTitle: "Interese & vocație",
        nextModuleDescription: "Vei explora ce tipuri de activități, domenii și medii de lucru se potrivesc mai bine cu tine.",
        onContinue: () => startModule3(context),
        onHome: () => Navigator.popUntil(context, (route) => route.isFirst),
      ),
    ),
  );
}
