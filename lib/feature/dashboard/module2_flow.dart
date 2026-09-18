import 'package:flutter/material.dart';
import 'package:futureme/core/data/big_five.dart';
import 'package:futureme/core/data/mbti.dart';
import 'package:futureme/core/data/mbti_summaries.dart';
import 'package:futureme/feature/chat/chat_flow.dart';
import 'package:futureme/feature/dashboard/dashboard_navigation.dart';
import 'package:futureme/feature/dashboard/module_answers.dart';
import 'package:futureme/feature/dashboard/templates/big_five_result_screen.dart';
import 'package:futureme/feature/dashboard/templates/module_complete_screen.dart';
import 'package:futureme/feature/dashboard/module_progress.dart';
import 'package:futureme/feature/dashboard/templates/insight_feedback_gate.dart';
import 'package:futureme/feature/dashboard/templates/module_feedback_summary_screen.dart';
import 'package:futureme/feature/dashboard/templates/module_final_feedback_screen.dart';
import 'package:futureme/feature/dashboard/templates/module_introduction_screen.dart';
import 'package:futureme/feature/dashboard/templates/module_mbti_question_screen.dart';
import 'package:futureme/feature/dashboard/templates/module_roadmap_screen.dart';
import 'package:futureme/feature/dashboard/templates/module_scale_question_screen.dart';
import 'package:futureme/feature/dashboard/module3_flow.dart';
import 'package:futureme/feature/dashboard/templates/stage_complete_screen.dart';

/// Wires the Module 2 screens into a push-based flow.
///
/// Stages 1 and 2 run the real instruments: the MBTI items in
/// `core/data/mbti.dart` and the IPIP-50 Big Five items in
/// `core/data/big_five.dart`. Both are scored by their own published keys,
/// and the result selects one of a fixed set of texts. No model is
/// involved, so the same answers always produce the same result.
///
/// PLACEHOLDER CONTENT: Stages 3-6 still run on small stand-in lists, since
/// their real question banks aren't available yet. Their feedback is still
/// model-generated as a result.

/// PLACEHOLDER CONTENT: Figma says "25 de afirmații scurte" but only shows
/// one example. Small stand-in list below.
const List<String> _stage3PlaceholderStatements = [
  "Prefer să înțeleg imaginea de ansamblu înainte de detalii.",
  "Analizez lucrurile pas cu pas, logic.",
  "Îmi place să leg ideile de exemple concrete.",
  "Am nevoie de timp să reflectez înainte să răspund.",
  "Lucrez mai bine când am pași clari de urmat.",
];

/// PLACEHOLDER CONTENT — see note on [_stage3PlaceholderStatements].
const List<String> _stage4PlaceholderStatements = [
  "Prefer să analizez toate opțiunile înainte să aleg.",
  "Uneori aleg pe baza intuiției, nu doar a logicii.",
  "Îmi place să cer părerea altora înainte de o decizie importantă.",
  "Prefer să iau decizii în ritmul meu, fără grabă.",
  "Amân o decizie când nu mă simt pregătită.",
];

/// PLACEHOLDER CONTENT — see note on [_stage3PlaceholderStatements].
const List<String> _stage5PlaceholderStatements = [
  "Simt presiune când am multe lucruri de făcut deodată.",
  "Mă îndoiesc de mine când trebuie să aleg repede.",
  "Îmi este greu să fiu blândă cu mine când ceva nu iese bine.",
  "Am nevoie de timp și liniște ca să îmi revin.",
  "Sub presiune, îmi este greu să văd clar.",
];

/// PLACEHOLDER CONTENT — see note on [_stage3PlaceholderStatements].
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
        moduleTitle: "Profil psihologic & stil decizional",
        description: "În acest modul explorăm cum gândești, iei decizii și reacționezi în situații diferite.",
        nextSteps: const [
          "Etape scurte, parcurse pe rând",
          "Răspunsuri sincere, nu perfecte",
          "Feedback scurt după fiecare etapă",
        ],
        continueLabel: "Vezi pașii modulului",
        progressNote: "Nu trebuie să termini totul dintr-o dată. Progresul tău este salvat.",
        onContinue: () {
          markModuleStarted('module2');
          _openRoadmap(context);
        },
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
            title: "Cum preferi să funcționezi",
            description: "Preferințele tale în felul în care interacționezi, procesezi informația și abordezi alegerile.",
          ),
          RoadmapStep(
            title: "Care este personalitatea ta",
            description: "Trăsăturile fundamentale care conturează felul în care gândești, simți și te comporți în mod constant.",
          ),
          RoadmapStep(
            title: "Cum gândești",
            description: "Felul în care observi, procesezi informația și abordezi problemele.",
          ),
          RoadmapStep(
            title: "Cum iei decizii",
            description: "Ce te ajută sau te încurcă atunci când trebuie să alegi.",
          ),
          RoadmapStep(
            title: "Cum reacționezi sub presiune",
            description: "Ce se întâmplă când apar stresul, emoțiile puternice sau îndoiala.",
          ),
          RoadmapStep(
            title: "Cât control simți că ai",
            description: "În ce măsură simți că poți influența ceea ce ți se întâmplă.",
          ),
        ],
        continueLabel: "Începe prima etapă",
        onContinue: () => _openStage1Intro(context),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Stage 1 — MBTI
// ---------------------------------------------------------------------------

void _openStage1Intro(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleIntroductionScreen(
        moduleLabel: "Etapa 1 din 6 · MBTI",
        moduleTitle: "Cum preferi să funcționezi",
        description: "Această etapă te ajută să observi cum te raportezi la oameni și la alegerile pe care le faci.",
        nextSteps: [
          "${mbtiItems.length} de perechi de afirmații",
          "Împarți 5 puncte între cele două variante",
          "Exemple valide: 0+5, 1+4, 2+3, 3+2, 4+1, 5+0",
        ],
        continueLabel: "Începe etapa",
        progressNote: "Distribuie cele 5 puncte proporțional cu măsura în care fiecare variantă se potrivește felului tău de a fi. Nu există răspunsuri corecte.",
        onContinue: () => _openStage1Question(context, 0, const {}),
      ),
    ),
  );
}

/// [answers] maps an item number to the points given to variant A, carried
/// forward from screen to screen so the whole questionnaire can be scored
/// in one go at the end.
void _openStage1Question(BuildContext context, int index, Map<int, int> answers) {
  final item = mbtiItems[index];
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleMbtiQuestionScreen(
        sectionLabel: "Cum preferi să funcționezi",
        statementA: item.statementA,
        statementB: item.statementB,
        questionNumber: index + 1,
        totalQuestions: mbtiItems.length,
        onContinue: (pointsForA, pointsForB) {
          saveModuleAnswer(
            'module2',
            'stage1_q${item.number}',
            type: 'mbti',
            value: {'pointsForA': pointsForA, 'pointsForB': pointsForB},
            stage: 1,
            questionNumber: item.number,
          );
          final next = {...answers, item.number: pointsForA};
          if (index + 1 < mbtiItems.length) {
            _openStage1Question(context, index + 1, next);
          } else {
            _openStage1Complete(context, scoreMbti(next));
          }
        },
      ),
    ),
  );
}

void _openStage1Complete(BuildContext context, MbtiResult result) {
  // The computed type is stored alongside the raw answers so the final
  // report can use it without rescoring — and so the result is auditable
  // against the answers it came from.
  saveModuleAnswer(
    'module2',
    'stage1_result',
    type: 'mbti_result',
    value: {
      'typeCode': result.typeCode,
      'isClearCut': result.isClearCut,
      'scores': {
        for (final entry in result.scores.entries) entry.key.name.toUpperCase(): entry.value,
      },
    },
    stage: 1,
  );

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => StageCompleteScreen(
        stageLabel: "Modulul 2 · Etapa 1 din 6",
        title: "Etapa 1 este completă",
        message:
            "Ai parcurs prima etapă a profilului tău. Răspunsurile tale rămân aici, iar în continuare le privim ca prime repere, nu ca o concluzie.",
        achievementTitle: "Cum preferi să funcționezi",
        achievementSubtitle: "${mbtiItems.length} de afirmații finalizate",
        infoNote: "Nu tragem concluzii încă. E doar primul pas. Profilul tău se construiește treptat.",
        primaryLabel: "Vezi rezultatul",
        onPrimary: () => _openStage1Feedback(context, result),
        secondaryLabel: "Revin mai târziu",
        onSecondary: () => goToDashboard(context),
      ),
    ),
  );
}

/// A one-line reading of each pole, used to describe whichever side won.
const Map<MbtiPole, String> _poleDescriptions = {
  MbtiPole.e: "Îți iei energia din contactul cu oamenii și din a fi în mijlocul lucrurilor.",
  MbtiPole.i: "Îți iei energia din liniște și din timpul petrecut cu propriile gânduri.",
  MbtiPole.s: "Te sprijini pe fapte concrete, detalii și pe ceea ce ai verificat din experiență.",
  MbtiPole.n: "Te sprijini pe intuiție, pe tipare și pe posibilitățile din spatele lucrurilor.",
  MbtiPole.t: "Când decizi, pornești de la logică și de la analiza faptelor.",
  MbtiPole.f: "Când decizi, ții cont de oameni, de valori și de ceea ce simți că e potrivit.",
  MbtiPole.j: "Preferi lucrurile planificate, structurate și stabilite din timp.",
  MbtiPole.p: "Preferi să rămâi flexibil și să decizi pe parcurs.",
};

const Map<MbtiDimension, (IconData, String)> _dimensionMeta = {
  MbtiDimension.energy: (Icons.bolt_outlined, "De unde îți iei energia"),
  MbtiDimension.perception: (Icons.lightbulb_outline, "Cum aduni informația"),
  MbtiDimension.judgement: (Icons.balance_outlined, "Cum iei decizii"),
  MbtiDimension.lifestyle: (Icons.event_note_outlined, "Cum îți organizezi viața"),
};

String _poleLetter(MbtiPole pole) => pole.name.toUpperCase();

List<SummaryItem> _mbtiSummaryItems(MbtiResult result) {
  return [
    for (final d in result.dimensions)
      SummaryItem(
        icon: _dimensionMeta[d.dimension]!.$1,
        title: _dimensionMeta[d.dimension]!.$2,
        badgeLabel: d.label,
        description: d.isTied
            ? "${_poleDescriptions[d.winner]!} Scorurile au ieșit egale (${_poleLetter(d.dimension.first)} ${d.firstScore} · ${_poleLetter(d.dimension.second)} ${d.secondScore}), deci pe această dimensiune preferința ta e mai puțin pronunțată."
            : "${_poleDescriptions[d.winner]!} (${_poleLetter(d.dimension.first)} ${d.firstScore} · ${_poleLetter(d.dimension.second)} ${d.secondScore})",
      ),
  ];
}

void _openStage1Feedback(BuildContext context, MbtiResult result) {
  final summary = mbtiSummaries[result.typeCode];

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleFeedbackSummaryScreen(
        moduleLabel: "Etapa 1 · Rezultatul tău",
        title: "Profilul tău începe să se contureze",
        description:
            "Rezultatul de mai jos vine direct din felul în care ți-ai împărțit punctele. Descrierea completă a tipului tău va fi inclusă în raportul final.",
        profileLabel: "Tipul tău",
        profileValue: result.typeCode,
        profileDescription: summary ?? "",
        summaryItems: _mbtiSummaryItems(result),
        infoNote: "Acesta este un reper, nu o etichetă. Următoarele etape vor adăuga context.",
        continueLabel: "Continuă cu Personalitatea ta",
        chatLabel: "Discută rezultatul în Chat",
        onContinue: () => _openStage2Intro(context),
        onChat: () => openChat(context, contextLabel: "Modulul 2 · Etapa 1 · ${result.typeCode}", continueLabel: "Continuă cu Personalitatea ta", onContinue: () => _openStage2Intro(context)),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Stage 2 — Big Five (IPIP-50)
// ---------------------------------------------------------------------------

void _openStage2Intro(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleIntroductionScreen(
        moduleLabel: "Etapa 2 din 6 · Big Five / OCEAN",
        moduleTitle: "Care este personalitatea ta",
        description:
            "Acest chestionar explorează 5 dimensiuni fundamentale ale personalității tale: deschidere către experiențe, conștiinciozitate, extraversie, agreabilitate și stabilitate emoțională.",
        nextSteps: [
          "${bigFiveItems.length} de afirmații scurte",
          "Alegi cât de adevărată se simte fiecare afirmație",
          "Descoperi cum se conturează cele 5 dimensiuni ale personalității tale",
        ],
        continueLabel: "Începem",
        progressNote: "Răspunde sincer, nu cum crezi că „ar trebui”.",
        onContinue: () => _openStage2Question(context, 0, const {}),
      ),
    ),
  );
}

/// [answers] maps an item number to the option the user picked, 1-5,
/// carried forward so the whole questionnaire is scored in one go.
void _openStage2Question(BuildContext context, int index, Map<int, int> answers) {
  final item = bigFiveItems[index];
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleScaleQuestionScreen(
        sectionLabel: "Care este personalitatea ta",
        statement: item.statement,
        options: bigFiveScaleLabels,
        questionNumber: index + 1,
        totalQuestions: bigFiveItems.length,
        onContinue: (selection) {
          // The screen reports a 0-based index; the instrument scores 1-5.
          final answer = selection + 1;
          saveModuleAnswer(
            'module2',
            'stage2_q${item.number}',
            type: 'scale',
            value: {'selectedIndex': selection, 'answer': answer},
            stage: 2,
            questionNumber: item.number,
          );
          final next = {...answers, item.number: answer};
          if (index + 1 < bigFiveItems.length) {
            _openStage2Question(context, index + 1, next);
          } else {
            _openStage2Complete(context, scoreBigFive(next));
          }
        },
      ),
    ),
  );
}

void _openStage2Complete(BuildContext context, BigFiveResult result) {
  // Stored the way the specification asks: the recoded score of every item,
  // plus each dimension's raw score, mean and band, so the result can be
  // audited against the raw answers saved alongside it.
  saveModuleAnswer(
    'module2',
    'stage2_result',
    type: 'big_five_result',
    value: {
      'version': 'ipip-50-ro-v1',
      'recoded': {for (final e in result.recodedAnswers.entries) '${e.key}': e.value},
      'dimensions': {
        for (final d in result.dimensions)
          d.dimension.name: {
            'rawScore': d.rawScore,
            'mean': d.mean,
            'level': d.level.name,
          },
      },
    },
    stage: 2,
  );

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => StageCompleteScreen(
        stageLabel: "Modulul 2 · Etapa 2 din 6",
        title: "Etapa 2 este completă",
        message:
            "Ai parcurs etapa despre personalitatea ta. Răspunsurile tale încep să așeze câteva repere, iar în continuare le privim fără concluzii fixe.",
        achievementTitle: "Care este personalitatea ta",
        achievementSubtitle: "${bigFiveItems.length} de afirmații finalizate",
        infoNote: "Nu trebuie să te recunoști perfect în fiecare reper. Căutăm direcții, nu definiții.",
        primaryLabel: "Vezi rezultatul",
        onPrimary: () => _openStage2Feedback(context, result),
        secondaryLabel: "Revin mai târziu",
        onSecondary: () => goToDashboard(context),
      ),
    ),
  );
}

void _openStage2Feedback(BuildContext context, BigFiveResult result) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => BigFiveResultScreen(
        result: result,
        onContinue: () => _openStage3Intro(context),
        onChat: () => openChat(context, contextLabel: "Modulul 2 · Etapa 2 · Profil de personalitate", continueLabel: "Continuă cu Stilul cognitiv", onContinue: () => _openStage3Intro(context)),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Stage 3 — Cognitive style (placeholder content)
// ---------------------------------------------------------------------------

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
          saveModuleAnswer(
            'module2',
            'stage3_q${index + 1}',
            type: 'scale',
            value: {'selectedIndex': selection},
            stage: 3,
            questionNumber: index + 1,
          );
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
        onSecondary: () => goToDashboard(context),
      ),
    ),
  );
}

void _openStage3Feedback(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => InsightFeedbackGate(
        scope: 'module2_stage3',
        moduleId: 'module2',
        stage: 3,
        loadingLabel: "Etapa 3 · Feedback scurt",
        builder: (context, insight) => ModuleFeedbackSummaryScreen(
          moduleLabel: "Etapa 3 · Feedback scurt",
          title: "Stilul tău de gândire începe să se clarifice",
          description: "Răspunsurile tale arată câteva indicii despre cum înveți, analizezi și abordezi problemele.",
          profileLabel: insight?.profileLabel,
          profileValue: insight?.profileValue,
          profileDescription: insight?.profileDescription,
          summaryItems: insight != null
              ? insightToSummaryItems(insight)
              : const [
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
          onChat: () => openChat(context, contextLabel: "Modulul 2 · Etapa 3 · Feedback scurt", continueLabel: "Continuă cu Stilul decizional", onContinue: () => _openStage4Intro(context)),
        ),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Stage 4 — Decision style (placeholder content)
// ---------------------------------------------------------------------------

void _openStage4Intro(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleIntroductionScreen(
        moduleLabel: "Etapa 4 din 6 · Stil decizional",
        moduleTitle: "Cum iei decizii",
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
        sectionLabel: "Cum iei decizii",
        statement: _stage4PlaceholderStatements[index],
        questionNumber: index + 1,
        totalQuestions: _stage4PlaceholderStatements.length,
        onContinue: (selection) {
          saveModuleAnswer(
            'module2',
            'stage4_q${index + 1}',
            type: 'scale',
            value: {'selectedIndex': selection},
            stage: 4,
            questionNumber: index + 1,
          );
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
        achievementTitle: "Cum iei decizii",
        achievementSubtitle: "20 de afirmații finalizate",
        infoNote: "Stilul tău decizional nu te limitează. Îți arată ce te poate ajuta să alegi mai clar.",
        primaryLabel: "Vezi feedbackul",
        onPrimary: () => _openStage4Feedback(context),
        secondaryLabel: "Revin mai târziu",
        onSecondary: () => goToDashboard(context),
      ),
    ),
  );
}

void _openStage4Feedback(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => InsightFeedbackGate(
        scope: 'module2_stage4',
        moduleId: 'module2',
        stage: 4,
        loadingLabel: "Etapa 4 · Feedback scurt",
        builder: (context, insight) => ModuleFeedbackSummaryScreen(
          moduleLabel: "Etapa 4 · Feedback scurt",
          title: "Stilul tău decizional se conturează",
          description: "Răspunsurile tale sugerează ce stil apare mai des atunci când ai de luat o decizie.",
          profileLabel: insight != null ? insight.profileLabel : "Stil decizional orientativ",
          profileValue: insight != null ? insight.profileValue : "Analitic",
          profileDescription: insight != null
              ? insight.profileDescription
              : "Alegi mai ușor când ai timp să înțelegi opțiunile, să compari argumentele și să vezi clar consecințele.",
          summaryItems: insight != null
              ? insightToSummaryItems(insight)
              : const [
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
          onChat: () => openChat(context, contextLabel: "Modulul 2 · Etapa 4 · Feedback scurt", continueLabel: "Continuă cu Tiparele emoționale", onContinue: () => _openStage5Intro(context)),
        ),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Stage 5 — Emotional patterns (placeholder content)
// ---------------------------------------------------------------------------

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
          saveModuleAnswer(
            'module2',
            'stage5_q${index + 1}',
            type: 'scale',
            value: {'selectedIndex': selection},
            stage: 5,
            questionNumber: index + 1,
          );
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
        onSecondary: () => goToDashboard(context),
      ),
    ),
  );
}

void _openStage5Feedback(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => InsightFeedbackGate(
        scope: 'module2_stage5',
        moduleId: 'module2',
        stage: 5,
        loadingLabel: "Etapa 5 · Feedback scurt",
        builder: (context, insight) => ModuleFeedbackSummaryScreen(
          moduleLabel: "Etapa 5 · Feedback scurt",
          title: "Cum reacționezi în momente solicitante",
          description:
              "Răspunsurile tale sugerează câteva repere despre ce te poate tensiona, ce îți poate scădea claritatea și ce te ajută să îți revii.",
          profileLabel: insight?.profileLabel,
          profileValue: insight?.profileValue,
          profileDescription: insight?.profileDescription,
          summaryItems: insight != null
              ? insightToSummaryItems(insight)
              : const [
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
          onChat: () => openChat(context, contextLabel: "Modulul 2 · Etapa 5 · Feedback scurt", continueLabel: "Continuă cu Controlul perceput", onContinue: () => _openStage6Intro(context)),
        ),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Stage 6 — Perceived control (placeholder content)
// ---------------------------------------------------------------------------

void _openStage6Intro(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleIntroductionScreen(
        moduleLabel: "Etapa 6 din 6 · Control perceput",
        moduleTitle: "Cât control simți că ai",
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
        sectionLabel: "Cât control simți că ai",
        statement: _stage6PlaceholderStatements[index],
        questionNumber: index + 1,
        totalQuestions: _stage6PlaceholderStatements.length,
        onContinue: (selection) {
          saveModuleAnswer(
            'module2',
            'stage6_q${index + 1}',
            type: 'scale',
            value: {'selectedIndex': selection},
            stage: 6,
            questionNumber: index + 1,
          );
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
        achievementTitle: "Cât control simți că ai",
        achievementSubtitle: "20 de afirmații finalizate",
        infoNote: "Ai ajuns la ultima piesă din acest modul. În curând le vom pune pe toate cap la cap.",
        primaryLabel: "Vezi feedbackul",
        onPrimary: () => _openStage6Feedback(context),
        secondaryLabel: "Revin mai târziu",
        onSecondary: () => goToDashboard(context),
      ),
    ),
  );
}

void _openStage6Feedback(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => InsightFeedbackGate(
        scope: 'module2_stage6',
        moduleId: 'module2',
        stage: 6,
        loadingLabel: "Etapa 6 · Feedback scurt",
        builder: (context, insight) => ModuleFeedbackSummaryScreen(
          moduleLabel: "Etapa 6 · Feedback scurt",
          title: "Cât control simți că ai",
          description:
              "Răspunsurile tale arată cum vezi lucrurile din jurul tău: ce simți că poți schimba prin alegerile tale și ce pare să depindă mai mult de context.",
          profileLabel: insight != null ? insight.profileLabel : "Profil orientativ",
          profileValue: insight != null ? insight.profileValue : "Echilibru realist",
          profileDescription: insight != null
              ? insight.profileDescription
              : "Pari să vezi că alegerile tale pot conta, chiar dacă unele lucruri țin și de context. Te poate ajuta să observi ce pas concret depinde de tine acum, fără să simți că trebuie să controlezi totul.",
          summaryItems: insight != null
              ? insightToSummaryItems(insight)
              : const [
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
          onChat: () => openChat(context, contextLabel: "Modulul 2 · Etapa 6 · Feedback scurt", continueLabel: "Vezi ce ai conturat în Modulul 2", onContinue: () => _openModule2FinalFeedback(context)),
        ),
      ),
    ),
  );
}

void _openModule2FinalFeedback(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => InsightFeedbackGate(
        scope: 'module2_final',
        moduleId: 'module2',
        loadingLabel: "Modulul 2 · Imagine de ansamblu",
        builder: (context, insight) => ModuleFinalFeedbackScreen(
          moduleLabel: "Modulul 2 · Imagine de ansamblu",
          title: "Ce ai înțeles despre tine în Modulul 2",
          description:
              "Cele 6 etape au privit lucrurile din unghiuri diferite. Împreună, ele arată cum gândești, cum alegi și ce ai nevoie ca să vezi mai clar direcția ta.",
          synthesisTitle: "Ce se conturează când le privim împreună",
          synthesisDescription: insight?.profileDescription ??
              "Se conturează un mod atent de a privi lucrurile, orientat spre sens și claritate. Pari să ai nevoie ca alegerile să aibă logică pentru tine, nu doar să pară corecte din exterior.",
          connectionsTitle: "Cum se leagă între ele",
          connections: insight != null && insight.items.isNotEmpty
              ? insightToConnectionItems(insight)
              : const [
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
          onChat: () => openChat(context, contextLabel: "Modulul 2 · Imagine de ansamblu", continueLabel: "Ascultă mesajul pentru tine", onContinue: () => _openModule2Complete(context)),
        ),
      ),
    ),
  );
}

void _openModule2Complete(BuildContext context) {
  ModuleProgress.markCompleted(2);
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
        onHome: () => goToDashboard(context),
      ),
    ),
  );
}