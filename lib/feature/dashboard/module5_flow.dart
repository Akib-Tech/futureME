import 'package:flutter/material.dart';
import 'package:futureme/core/auth/auth_service.dart';
import 'package:futureme/core/data/ai_content_repository.dart';
import 'package:futureme/core/data/module_progress_repository.dart';
import 'package:futureme/core/data/user_repository.dart';
import 'package:futureme/core/di/injectable_init.dart';
import 'package:futureme/core/report/report_pdf_actions.dart';
import 'package:futureme/feature/chat/chat_flow.dart';
import 'package:futureme/feature/dashboard/dashboard_navigation.dart';
import 'package:futureme/feature/dashboard/module_answers.dart';
import 'package:futureme/feature/dashboard/module5/module5_complete_screen.dart';
import 'package:futureme/feature/dashboard/module_progress.dart';
import 'package:futureme/feature/dashboard/module5/module5_plan_screen.dart';
import 'package:futureme/feature/dashboard/module5/module5_report_preview_screen.dart';
import 'package:futureme/feature/dashboard/module5/module5_report_ready_screen.dart';
import 'package:futureme/feature/dashboard/templates/insight_feedback_gate.dart';
import 'package:futureme/feature/dashboard/templates/module_audio_message_screen.dart';
import 'package:futureme/feature/dashboard/templates/module_final_feedback_screen.dart';
import 'package:futureme/feature/dashboard/templates/module_introduction_screen.dart';
import 'package:futureme/feature/dashboard/templates/module_loading_screen.dart';
import 'package:futureme/feature/dashboard/templates/tagged_card_list_screen.dart';

/// Fetches modules 1-4's saved answers for the current user, shaped for a
/// Cloud Function payload (mirrors [InsightFeedbackGate]'s own fetch).
Future<List<Map<String, dynamic>>> _fetchAnswersAcross(List<String> moduleIds) async {
  final uid = getIt<AuthService>().currentUser?.uid;
  if (uid == null) return const [];
  final repo = getIt<ModuleProgressRepository>();
  final answers = <Map<String, dynamic>>[];
  for (final moduleId in moduleIds) {
    answers.addAll(await repo.fetchAnswers(uid, moduleId));
  }
  return answers;
}

/// Wires the Module 5 screens ("Drumul tău mai departe") into a
/// push-based flow. Module 5 is flat and linear — no stages, no
/// Roadmap — and unlike Modules 1-4 most of its screens are unique
/// layouts (tagged card lists, a plan screen, report screens) rather
/// than the shared question/feedback templates.
///
/// Report Loading 2 (Figma frame 487:2349, "Încă puțin") is built as a
/// standalone widget but NOT wired into this flow: Figma's own
/// annotation says it should only appear if report generation takes
/// longer than 15-20 seconds, which requires real backend timing this
/// app doesn't have. Report Loading 1 always auto-advances to Report
/// Ready after a short simulated delay instead.
void startModule5(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleIntroductionScreen(
        moduleLabel: "Modulul 5",
        moduleTitle: "Drumul tău mai departe",
        description:
            "Până acum ai descoperit repere importante despre tine: ce îți dorești, cum funcționezi, ce te atrage și ce puncte forte se văd mai clar. Acum le punem împreună, ca să vezi ce direcții și pași concreți pot avea sens pentru tine.",
        richNextSteps: const [
          ConnectionItem(
            icon: Icons.dashboard_outlined,
            title: "Imagine de ansamblu",
            description: "Punem împreună reperele din modulele parcurse.",
          ),
          ConnectionItem(
            icon: Icons.explore_outlined,
            title: "Direcții și recomandări",
            description: "Vezi ce opțiuni merită explorate și ce te poate ajuta să alegi mai clar.",
          ),
          ConnectionItem(
            icon: Icons.description_outlined,
            title: "Planul și raportul tău",
            description: "Încheiem cu pași practici și un raport pe care îl poți reciti oricând.",
          ),
        ],
        continueLabel: "Vezi imaginea de ansamblu",
        progressNote: "Nu trebuie să decizi totul acum. Modulul acesta te ajută să vezi mai clar ce merită explorat în continuare.",
        onContinue: () {
          markModuleStarted('module5');
          _openPersonalProfile(context);
        },
      ),
    ),
  );
}

void _openPersonalProfile(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => InsightFeedbackGate(
        scope: 'module5_synthesis',
        moduleId: 'module1',
        alsoFromModules: const ['module2', 'module3', 'module4'],
        loadingLabel: "Modulul 5 · Imagine de ansamblu",
        builder: (context, insight) => ModuleFinalFeedbackScreen(
          moduleLabel: "Modulul 5 · Imagine de ansamblu",
          title: "Ce se vede când punem totul împreună",
          description: "Răspunsurile tale încep să arate cum funcționezi, ce te atrage și ce ai nevoie ca să alegi mai clar.",
          synthesisTitle: "Pe scurt",
          synthesisDescription: insight?.profileDescription ??
              "Pari să funcționezi mai bine când ai spațiu să gândești, repere clare și sens în ceea ce faci. Direcțiile care merită explorate par să combine idei, oameni și sens.",
          connectionsTitle: "Reperele tale principale",
          connections: insight != null && insight.items.isNotEmpty
              ? insightToConnectionItems(insight)
              : const [
                  ConnectionItem(
                    icon: Icons.favorite_border,
                    title: "Ce îți dorești acum",
                    description: "Mai multă claritate și un drum care să se simtă potrivit pentru tine, nu doar corect „pe hârtie”.",
                  ),
                  ConnectionItem(
                    icon: Icons.psychology_outlined,
                    title: "Cum funcționezi mai bine",
                    description: "Ai nevoie de timp, sens și repere clare ca să nu te pierzi în prea multe variante.",
                  ),
                  ConnectionItem(
                    icon: Icons.explore_outlined,
                    title: "Ce te atrage",
                    description: "Par să merite explorate zone în care lucrezi cu idei, oameni și înțelegere.",
                  ),
                  ConnectionItem(
                    icon: Icons.star_border,
                    title: "Ce puncte forte se văd",
                    description: "Analiza, comunicarea și organizarea par să fie zone pe care poți construi mai departe.",
                  ),
                ],
          infoNote: "Nu este o concluzie finală. Este o imagine de ansamblu care ne ajută să alegem direcții mai potrivite de explorat.",
          continueLabel: "Vezi direcțiile de explorat",
          onContinue: () => _openCareerPlanGate(context),
        ),
      ),
    ),
  );
}

/// Maps a Claude-generated [GeneratedTaggedCard] to the [TaggedCard] the
/// tagged-card-list screens render.
TaggedCard _toTaggedCard(GeneratedTaggedCard c) => TaggedCard(
      pillLabel: c.pillLabel,
      pillTone: switch (c.pillTone) {
        GeneratedCardTone.primary => CardPillTone.primary,
        GeneratedCardTone.warm => CardPillTone.warm,
        GeneratedCardTone.subtle => CardPillTone.subtle,
        null => null,
      },
      title: c.title,
      description: c.description,
      tags: c.tags,
    );

PlanStep _toPlanStep(GeneratedPlanStep s) =>
    PlanStep(title: s.title, periodLabel: s.periodLabel, description: s.description, checklist: s.checklist);

/// Fetches the per-user career plan (or falls back to null, meaning every
/// downstream screen uses its fixed content), then replaces itself with the
/// Directions screen.
void _openCareerPlanGate(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => const _CareerPlanGate()));
}

class _CareerPlanGate extends StatefulWidget {
  const _CareerPlanGate();

  @override
  State<_CareerPlanGate> createState() => _CareerPlanGateState();
}

class _CareerPlanGateState extends State<_CareerPlanGate> {
  @override
  void initState() {
    super.initState();
    _resolve();
  }

  Future<void> _resolve() async {
    GeneratedCareerPlan? plan;
    try {
      final answers = await _fetchAnswersAcross(const ['module1', 'module2', 'module3', 'module4']);
      if (answers.isNotEmpty) {
        plan = await getIt<AiContentRepository>().careerPlan(answers: answers);
      }
    } catch (_) {
      plan = null;
    }
    if (!mounted) return;
    _openDirections(context, plan, replace: true);
  }

  @override
  Widget build(BuildContext context) => const ModuleLoadingScreen(
        moduleLabel: "Modulul 5 · Direcții",
        title: "Pregătim direcțiile tale",
        description: "Punem cap la cap reperele din modulele parcurse. Durează câteva secunde.",
        reminderText: "Acestea sunt puncte de pornire, nu alegeri finale.",
      );
}

void _openDirections(BuildContext context, GeneratedCareerPlan? plan, {bool replace = false}) {
  final route = MaterialPageRoute(
    builder: (context) => TaggedCardListScreen(
        moduleLabel: "Modulul 5 · Direcții",
        title: "Direcții care merită explorate",
        description:
            "Pe baza răspunsurilor tale, se conturează câteva direcții care merită explorate mai departe. Nu sunt alegeri finale, ci puncte de pornire.",
        tagsLabel: "Ce poți explora:",
        cards: plan != null ? plan.directions.map(_toTaggedCard).toList() : const [
          TaggedCard(
            pillLabel: "Potrivire ridicată",
            pillTone: CardPillTone.primary,
            title: "UX / Product Design",
            description:
                "Poate avea sens pentru tine pentru că îmbină analiza, creativitatea și înțelegerea oamenilor. Este o direcție în care poți transforma observațiile în soluții clare și utile.",
            tags: ["Interfețe digitale", "Prototipare", "Experiență de utilizare"],
          ),
          TaggedCard(
            pillLabel: "Merită explorată",
            pillTone: CardPillTone.warm,
            title: "Psihologie / Consiliere",
            description:
                "Poate fi o direcție potrivită dacă te atrage să înțelegi oamenii, să asculți cu atenție și să oferi sprijin într-un mod structurat și empatic.",
            tags: ["Consiliere", "Orientare vocațională", "Psihologie educațională", "Suport emoțional"],
          ),
          TaggedCard(
            pillLabel: "Merită explorată",
            pillTone: CardPillTone.warm,
            title: "Comunicare & Content",
            description:
                "Poate avea sens dacă îți place să explici idei, să creezi mesaje clare și să dai formă unor lucruri care pentru alții par greu de pus în cuvinte.",
            tags: ["Content writing", "Storytelling", "Social media", "Strategie de comunicare"],
          ),
          TaggedCard(
            pillLabel: "De luat în calcul",
            pillTone: CardPillTone.subtle,
            title: "Research / Analiză",
            description:
                "Poate deveni o direcție bună dacă îți place să înțelegi lucrurile în profunzime, să observi tipare și să lucrezi cu informații înainte de a trage concluzii.",
            tags: ["User research", "Analiză de date", "Cercetare", "Strategie"],
          ),
          TaggedCard(
            pillLabel: "De luat în calcul",
            pillTone: CardPillTone.subtle,
            title: "Educație / Training",
            description: "Poate avea sens dacă îți place să explici, să ghidezi și să ajuți oamenii să înțeleagă mai ușor lucruri importante pentru ei.",
            tags: ["Training", "Mentorat", "Educație non-formală", "Materiale de învățare"],
          ),
        ],
        infoNote: "Aceste direcții sunt puncte de pornire. Unele se leagă mai clar de reperele tale de acum, iar altele pot merita explorate mai departe.",
        continueLabel: "Vezi impactul AI",
        onContinue: () => _openAiImpact(context, plan),
      ),
  );
  if (replace) {
    Navigator.pushReplacement(context, route);
  } else {
    Navigator.push(context, route);
  }
}

void _openAiImpact(BuildContext context, GeneratedCareerPlan? plan) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => TaggedCardListScreen(
        moduleLabel: "Modulul 5 • Impactul AI",
        title: "Cum pot evolua aceste direcții",
        description:
            "AI poate schimba o parte din felul în care se lucrează în aceste domenii. Asta nu înseamnă că direcțiile își pierd valoarea, ci că unele abilități pot deveni mai importante în timp.",
        tagsLabel: "Ce rămâne valoros:",
        cards: plan != null ? plan.aiImpact.map(_toTaggedCard).toList() : const [
          TaggedCard(
            pillLabel: "Impact AI moderat",
            pillTone: CardPillTone.warm,
            title: "UX / Product Design",
            description:
                "AI poate accelera ideile, wireframe-urile, prototipurile și variantele vizuale. Diferența rămâne în felul în care înțelegi oamenii, clarifici problema și iei decizii de design.",
            tags: ["Research", "Empatie", "Gândire strategică", "Decizii de produs"],
          ),
          TaggedCard(
            pillLabel: "Impact AI redus",
            pillTone: CardPillTone.primary,
            title: "Psihologie / Consiliere",
            description:
                "AI poate susține reflecția sau accesul la informații, dar nu poate înlocui relația umană, ascultarea atentă și responsabilitatea profesională.",
            tags: ["Relație umană", "Empatie", "Etică", "Ghidaj personalizat"],
          ),
          TaggedCard(
            pillLabel: "Impact AI moderat",
            pillTone: CardPillTone.warm,
            title: "Comunicare & Content",
            description:
                "AI poate genera rapid texte, idei și variante de conținut. Direcția rămâne valoroasă când implică strategie, voce autentică și înțelegerea publicului.",
            tags: ["Strategie", "Storytelling", "Voce de brand", "Gândire editorială"],
          ),
          TaggedCard(
            pillLabel: "Impact AI moderat",
            pillTone: CardPillTone.warm,
            title: "Research / Analiză",
            description:
                "AI poate organiza informații, sintetiza date și observa tipare. Valoarea umană rămâne în întrebările bune, interpretare și înțelegerea contextului.",
            tags: ["Gândire critică", "Interpretare", "Structurare", "Context"],
          ),
          TaggedCard(
            pillLabel: "Impact AI moderat",
            pillTone: CardPillTone.warm,
            title: "Educație / Training",
            description:
                "AI poate ajuta la crearea de materiale, exerciții și explicații. Ce rămâne important este felul în care ghidezi oamenii, adaptezi informația și susții învățarea.",
            tags: ["Claritate", "Ghidaj", "Adaptare", "Relație cu oamenii"],
          ),
        ],
        infoNote: "Impactul AI nu elimină automat o direcție. Te ajută să vezi ce se poate schimba și ce abilități merită dezvoltate ca să rămâi adaptabil.",
        continueLabel: "Vezi recomandările tale",
        onContinue: () => _openRecommendations(context, plan),
      ),
    ),
  );
}

void _openRecommendations(BuildContext context, GeneratedCareerPlan? plan) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => TaggedCardListScreen(
        moduleLabel: "Modulul 5 · Recomandări",
        title: "Ce te poate ajuta să alegi mai clar",
        description:
            "Direcțiile conturate pentru tine pot fi mai ușor de explorat când ai câteva repere clare. Aceste recomandări te ajută să vezi ce merită căutat, testat sau evitat mai departe.",
        tagsLabel: "Exemple:",
        cards: plan != null
            ? plan.recommendations.map((r) => TaggedCard(title: r.title, description: r.description, tags: const [])).toList()
            : const [
          TaggedCard(
            title: "Caută combinația dintre idei, oameni și structură",
            description:
                "Pentru tine, par să aibă sens direcțiile în care poți lucra cu idei, poți înțelege oamenii și poți construi ceva clar. Rolurile care combină analiza cu partea umană pot fi un punct bun de pornire.",
            tags: [],
          ),
          TaggedCard(
            title: "Testează direcțiile înainte să alegi",
            description: "Poate fi mai util să testezi puțin: un proiect mic, un curs scurt sau o conversație cu cineva din domeniu.",
            tags: [],
          ),
          TaggedCard(
            title: "Alege medii cu repere clare",
            description:
                "Pari să funcționezi mai bine când ai structură, pași clari și suficient timp să înțelegi lucrurile înainte să decizi. Un mediu foarte haotic sau lipsit de direcție s-ar putea să te consume mai mult decât să te ajute.",
            tags: [],
          ),
          TaggedCard(
            title: "Construiește pe analiză și comunicare",
            description: "Merită să dezvolți abilități precum research-ul, comunicarea clară și înțelegerea oamenilor.",
            tags: [],
          ),
          TaggedCard(
            title: "Nu exclude o direcție prea repede",
            description: "Impactul AI nu înseamnă automat că o direcție nu mai merită explorată. Mai important este să vezi ce se schimbă și ce rămâne valoros.",
            tags: [],
          ),
          TaggedCard(
            title: "Nu alege doar din presiune",
            description:
                "Dacă o opțiune pare „corectă” doar pentru că sună sigură, cunoscută sau apreciată de alții, merită verificat dacă se potrivește și cu felul tău de a funcționa. Claritatea apare mai ușor când alegerea are sens și pentru tine.",
            tags: [],
          ),
        ],
        infoNote: "Nu trebuie să aplici toate recomandările deodată. Alege una sau două care par cele mai utile acum și folosește-le ca punct de plecare.",
        continueLabel: "Vezi opțiunile de formare",
        onContinue: () => _openTraining(context, plan),
      ),
    ),
  );
}

void _openTraining(BuildContext context, GeneratedCareerPlan? plan) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => TaggedCardListScreen(
        moduleLabel: "Modulul 5 • Formare",
        title: "Cum poți începe să te pregătești",
        description:
            "Direcțiile conturate pentru tine pot avea mai multe rute de explorare. Unele pot cere studii mai lungi, iar altele pot fi testate prin cursuri, proiecte, mentorat sau experiență practică.",
        tagsLabel: "Exemple:",
        cards: plan != null ? plan.training.map(_toTaggedCard).toList() : const [
          TaggedCard(
            title: "Studii universitare",
            description: "Pot fi utile pentru direcțiile care cer o bază academică mai clară, o calificare oficială sau un parcurs profesional reglementat.",
            tags: ["Psihologie", "Științe cognitive", "Comunicare", "Design", "Educație"],
          ),
          TaggedCard(
            title: "Cursuri & certificări",
            description:
                "Pot fi o variantă bună dacă vrei să testezi mai rapid o direcție, să înveți o abilitate concretă sau să vezi dacă domeniul ți se potrivește în practică.",
            tags: ["UX Design", "User Research", "Content Strategy", "Facilitation", "Data Analysis"],
          ),
          TaggedCard(
            title: "Experiență practică",
            description:
                "Pentru unele direcții, claritatea apare mai ușor când încerci ceva real, chiar la scară mică. Un proiect, un internship sau o conversație cu cineva din domeniu te pot ajuta să înțelegi cum arată munca de zi cu zi.",
            tags: ["Portofoliu", "Voluntariat", "Internship", "Mentorat", "Proiecte personale"],
          ),
        ],
        infoNote:
            "Nu există o singură rută corectă. Important este să alegi o cale care se potrivește cu ritmul tău, cu resursele tale și cu direcția pe care vrei să o testezi mai întâi.",
        continueLabel: "Vezi planul tău",
        onContinue: () => _openPlan(context, plan),
      ),
    ),
  );
}

void _openPlan(BuildContext context, GeneratedCareerPlan? careerPlan) {
  final plan = careerPlan?.plan;
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Module5PlanScreen(
        moduleLabel: "Modulul 5 • Plan",
        title: "Următorii tăi pași",
        description: "Ai văzut câteva direcții care pot avea sens pentru tine. Acum pornim de la una dintre ele și o transformăm în pași simpli, ușor de urmat.",
        directionLabel: "Direcția de pornire",
        directionTitle: plan?.directionTitle ?? "UX / Product Design",
        directionDescription: plan?.directionDescription ?? "O poți explora treptat fără să o transformi imediat într-o alegere finală.",
        firstStepTitle: plan?.firstStepTitle ?? "Primul pas",
        firstStepDescription: plan?.firstStepDescription ??
            "În următoarele 7 zile, uită-te la 2–3 proiecte reale din această direcție. Notează ce te atrage și ce ai vrea să înveți mai departe.",
        planSectionLabel: "Planul tău în 3 etape",
        steps: plan != null
            ? plan.steps.map(_toPlanStep).toList()
            : const [
                PlanStep(
                  title: "Explorează",
                  periodLabel: "2-4 săptămâni",
                  description: "Înțelege cum arată munca reală în această direcție.",
                  checklist: ["Uită-te la proiecte reale", "Caută un curs introductiv", "Notează ce te atrage și ce nu simți că ți se potrivește"],
                ),
                PlanStep(title: "Testează", periodLabel: "1-3 luni", description: "Claritatea apare mai ușor când încerci ceva concret."),
                PlanStep(
                  title: "Clarifică",
                  periodLabel: "3-6 luni",
                  description: "După ce ai testat direcția, uită-te la ce ai observat și decide ce merită continuat.",
                ),
              ],
        infoNote: "Planul acesta este un punct de pornire. Îl poți ajusta pe măsură ce descoperi ce ți se potrivește mai bine.",
        continueLabel: "Ascultă mesajul tău",
        onContinue: () => _openAudioMessage(context),
      ),
    ),
  );
}

void _openAudioMessage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleAudioMessageScreen(
        moduleLabel: "Modulul 5 • Mesaj pentru tine",
        title: "Un moment înainte de raportul tău",
        description:
            "Ai parcurs o etapă importantă. Înainte să vezi raportul tău, ascultă un mesaj scurt care îți amintește că nu trebuie să ai toate răspunsurile acum. Poți merge mai departe, pas cu pas, în ritmul tău.",
        messageTitle: "Mesaj pentru tine",
        messageSubtitle: "Un moment scurt de încurajare înainte de raportul tău.",
        continueLabel: "Continuă către raport",
        onContinue: () => _openReportLoading(context),
      ),
    ),
  );
}

/// Generates the real final report (via `generateFinalReport`, from the
/// user's full Module 1-5 answers) and persists it, then advances to Report
/// Ready. Falls back to `status: 'not_generated'` if generation fails/isn't
/// deployed — the Report tab already handles that state gracefully.
void _openReportLoading(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => const _ReportGenerationGate()));
}

class _ReportGenerationGate extends StatefulWidget {
  const _ReportGenerationGate();

  @override
  State<_ReportGenerationGate> createState() => _ReportGenerationGateState();
}

class _ReportGenerationGateState extends State<_ReportGenerationGate> {
  @override
  void initState() {
    super.initState();
    _resolve();
  }

  Future<void> _resolve() async {
    final uid = getIt<AuthService>().currentUser?.uid;
    GeneratedReport? report;
    if (uid != null) {
      try {
        final answers = await _fetchAnswersAcross(const ['module1', 'module2', 'module3', 'module4', 'module5']);
        report = answers.isNotEmpty ? await getIt<AiContentRepository>().finalReport(answers: answers) : null;
        if (report != null) {
          await getIt<UserRepository>().saveFinalReport(
            uid,
            summary: report.summary,
            sections: [for (final s in report.sections) {'title': s.title, 'body': s.body}],
          );
        } else {
          await getIt<UserRepository>().markFinalReportNotGenerated(uid);
        }
      } catch (_) {
        report = null;
        await getIt<UserRepository>().markFinalReportNotGenerated(uid);
      }
    }
    if (!mounted) return;
    _openReportReady(context, report);
  }

  @override
  Widget build(BuildContext context) => const ModuleLoadingScreen(
        moduleLabel: "Modulul 5 • Raport",
        title: "Pregătim raportul tău",
        description: "Punem cap la cap răspunsurile, direcțiile, recomandările și pașii tăi. Mai durează puțin.",
        reminderText: "Raportul tău se pregătește...",
      );
}

void _openReportReady(BuildContext context, GeneratedReport? report) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => Module5ReportReadyScreen(
        moduleLabel: "Modulul 5 • Raport",
        title: "Raportul tău este gata",
        description: "Raportul dezvoltă mai pe larg rezultatele pe care le-ai văzut în aplicație, cu explicații, recomandări și un plan la care poți reveni oricând.",
        achievementTitle: "Raportul tău FutureMe",
        pillLabel: "Raport personalizat • PDF",
        achievementDescription: "Profilul tău și stilul decizional, interesele, punctele forte, direcțiile profesionale, impactul AI, opțiunile de formare și planul tău.",
        infoNote: "După ce vezi raportul, mai urmează un audio ghidat ales în funcție de rezultatele tale.",
        continueLabel: "Vezi raportul",
        onContinue: () => _openReportPreview(context, report),
      ),
    ),
  );
}

void _openReportPreview(BuildContext context, GeneratedReport? report) {
  final sections = report == null ? null : [for (final s in report.sections) {'title': s.title, 'body': s.body}];
  final userName = getIt<AuthService>().currentUser?.displayName?.trim();
  final displayName = (userName?.isNotEmpty ?? false) ? userName! : "Contul tău";
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Module5ReportPreviewScreen(
        titleLabel: "Raportul tău",
        primaryLabel: "Ascultă audio-ul ghidat",
        chatLabel: "Discută raportul în Chat",
        summary: report?.summary,
        sections: sections,
        onDownload: sections == null ? null : () => downloadReportPdf(userName: displayName, summary: report?.summary, sections: sections),
        onShare: sections == null ? null : () => shareReportPdf(userName: displayName, summary: report?.summary, sections: sections),
        onPrimary: () => _openGuidedAudio(context),
        onChat: () => openChat(context, contextLabel: "Modulul 5 · Raportul tău", continueLabel: "Ascultă audio-ul ghidat", onContinue: () => _openGuidedAudio(context)),
      ),
    ),
  );
}

void _openGuidedAudio(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleAudioMessageScreen(
        moduleLabel: "Modulul 5 • Audio ghidat",
        title: "Un audio ales pentru tine",
        description:
            "Pe baza rezultatelor tale, am ales un audio ghidat care te ajută să închei acest parcurs cu mai multă claritate și încredere în pașii următori.",
        messageTitle: "Încredere în propriul ritm",
        messageSubtitle: "Un audio ghidat care îți susține claritatea și încrederea în propriul ritm.",
        infoNote: "Îl poți asculta acum sau mai târziu. După finalizarea parcursului, îl vei găsi în secțiunea Raport.",
        continueLabel: "Finalizează parcursul",
        onContinue: () => _openModule5Complete(context),
      ),
    ),
  );
}

void _openModule5Complete(BuildContext context) {
  ModuleProgress.markCompleted(5);
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => Module5CompleteScreen(
        title: "Parcursul tău FutureMe este complet",
        description: "Ai ajuns la final. Acum ai o imagine mai clară despre tine, direcțiile pe care le poți explora și pașii cu care poți începe.",
        continueLabel: "Vezi progresul tău",
        onContinue: () => goToDashboard(context),
      ),
    ),
  );
}
