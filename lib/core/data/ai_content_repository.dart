import 'package:cloud_functions/cloud_functions.dart';
import 'package:injectable/injectable.dart';

const _callTimeout = Duration(seconds: 25);

/// One reflective question generated for Module 1.
class GeneratedQuestion {
  const GeneratedQuestion({
    required this.question,
    required this.subtitle,
    required this.placeholder,
    this.hint,
  });

  final String question;
  final String subtitle;
  final String placeholder;
  final String? hint;

  static GeneratedQuestion fromMap(Map<String, dynamic> m) => GeneratedQuestion(
        question: (m['question'] as String?) ?? '',
        subtitle: (m['subtitle'] as String?) ?? '',
        placeholder: (m['placeholder'] as String?) ?? 'Scrie aici...',
        hint: (m['hint'] as String?)?.trim().isNotEmpty ?? false ? m['hint'] as String : null,
      );
}

/// 'low' | 'medium' | 'high'
enum InsightLevel { low, medium, high }

InsightLevel? _levelFrom(Object? raw) {
  switch (raw) {
    case 'low':
      return InsightLevel.low;
    case 'medium':
      return InsightLevel.medium;
    case 'high':
      return InsightLevel.high;
    default:
      return null;
  }
}

class GeneratedInsightItem {
  const GeneratedInsightItem({required this.title, required this.description, this.level});

  final String title;
  final String description;
  final InsightLevel? level;

  static GeneratedInsightItem fromMap(Map<String, dynamic> m) => GeneratedInsightItem(
        title: (m['title'] as String?) ?? '',
        description: (m['description'] as String?) ?? '',
        level: _levelFrom(m['level']),
      );
}

/// Per-user interpretation of one module/stage — mirrors the `generateInsight`
/// Cloud Function response (see `functions/ai.js`).
class GeneratedInsight {
  const GeneratedInsight({
    this.profileLabel,
    this.profileValue,
    this.profileDescription,
    required this.items,
  });

  final String? profileLabel;
  final String? profileValue;
  final String? profileDescription;
  final List<GeneratedInsightItem> items;

  static GeneratedInsight fromMap(Map<String, dynamic> m) => GeneratedInsight(
        profileLabel: m['profileLabel'] as String?,
        profileValue: m['profileValue'] as String?,
        profileDescription: m['profileDescription'] as String?,
        items: ((m['items'] as List?) ?? const [])
            .map((e) => GeneratedInsightItem.fromMap(Map<String, dynamic>.from(e as Map)))
            .toList(),
      );
}

/// 'primary' | 'warm' | 'subtle' — mirrors `CardPillTone` in
/// `tagged_card_list_screen.dart`.
enum GeneratedCardTone { primary, warm, subtle }

GeneratedCardTone? _toneFrom(Object? raw) => switch (raw) {
      'primary' => GeneratedCardTone.primary,
      'warm' => GeneratedCardTone.warm,
      'subtle' => GeneratedCardTone.subtle,
      _ => null,
    };

/// One Module 5 "tagged card" (a career direction or its AI-impact
/// counterpart, or a training option) — mirrors the `TaggedCard` shape.
class GeneratedTaggedCard {
  const GeneratedTaggedCard({required this.title, required this.description, required this.tags, this.pillLabel, this.pillTone});

  final String title;
  final String description;
  final List<String> tags;
  final String? pillLabel;
  final GeneratedCardTone? pillTone;

  static GeneratedTaggedCard fromMap(Map<String, dynamic> m) => GeneratedTaggedCard(
        title: (m['title'] as String?) ?? '',
        description: (m['description'] as String?) ?? '',
        tags: ((m['tags'] as List?) ?? const []).map((e) => e.toString()).toList(),
        pillLabel: m['pillLabel'] as String?,
        pillTone: _toneFrom(m['pillTone']),
      );
}

class GeneratedRecommendation {
  const GeneratedRecommendation({required this.title, required this.description});

  final String title;
  final String description;

  static GeneratedRecommendation fromMap(Map<String, dynamic> m) =>
      GeneratedRecommendation(title: (m['title'] as String?) ?? '', description: (m['description'] as String?) ?? '');
}

class GeneratedPlanStep {
  const GeneratedPlanStep({required this.title, required this.periodLabel, required this.description, this.checklist});

  final String title;
  final String periodLabel;
  final String description;
  final List<String>? checklist;

  static GeneratedPlanStep fromMap(Map<String, dynamic> m) => GeneratedPlanStep(
        title: (m['title'] as String?) ?? '',
        periodLabel: (m['periodLabel'] as String?) ?? '',
        description: (m['description'] as String?) ?? '',
        checklist: (m['checklist'] as List?)?.map((e) => e.toString()).toList(),
      );
}

class GeneratedPlan {
  const GeneratedPlan({
    required this.directionTitle,
    required this.directionDescription,
    required this.firstStepTitle,
    required this.firstStepDescription,
    required this.steps,
  });

  final String directionTitle;
  final String directionDescription;
  final String firstStepTitle;
  final String firstStepDescription;
  final List<GeneratedPlanStep> steps;

  static GeneratedPlan fromMap(Map<String, dynamic> m) => GeneratedPlan(
        directionTitle: (m['directionTitle'] as String?) ?? '',
        directionDescription: (m['directionDescription'] as String?) ?? '',
        firstStepTitle: (m['firstStepTitle'] as String?) ?? '',
        firstStepDescription: (m['firstStepDescription'] as String?) ?? '',
        steps: ((m['steps'] as List?) ?? const []).map((e) => GeneratedPlanStep.fromMap(Map<String, dynamic>.from(e as Map))).toList(),
      );
}

/// Module 5's per-user career plan — directions, their AI-impact readout,
/// practical recommendations, training options and a 3-step plan. Mirrors
/// the `generateCareerPlan` Cloud Function response.
class GeneratedCareerPlan {
  const GeneratedCareerPlan({
    required this.directions,
    required this.aiImpact,
    required this.recommendations,
    required this.training,
    required this.plan,
  });

  final List<GeneratedTaggedCard> directions;
  final List<GeneratedTaggedCard> aiImpact;
  final List<GeneratedRecommendation> recommendations;
  final List<GeneratedTaggedCard> training;
  final GeneratedPlan plan;

  static GeneratedCareerPlan fromMap(Map<String, dynamic> m) => GeneratedCareerPlan(
        directions: ((m['directions'] as List?) ?? const []).map((e) => GeneratedTaggedCard.fromMap(Map<String, dynamic>.from(e as Map))).toList(),
        aiImpact: ((m['aiImpact'] as List?) ?? const []).map((e) => GeneratedTaggedCard.fromMap(Map<String, dynamic>.from(e as Map))).toList(),
        recommendations:
            ((m['recommendations'] as List?) ?? const []).map((e) => GeneratedRecommendation.fromMap(Map<String, dynamic>.from(e as Map))).toList(),
        training: ((m['training'] as List?) ?? const []).map((e) => GeneratedTaggedCard.fromMap(Map<String, dynamic>.from(e as Map))).toList(),
        plan: GeneratedPlan.fromMap(Map<String, dynamic>.from((m['plan'] as Map?) ?? const {})),
      );
}

class GeneratedReportSection {
  const GeneratedReportSection({required this.title, required this.body});

  final String title;
  final String body;

  static GeneratedReportSection fromMap(Map<String, dynamic> m) =>
      GeneratedReportSection(title: (m['title'] as String?) ?? '', body: (m['body'] as String?) ?? '');
}

/// The final personalized report — mirrors the `generateFinalReport` Cloud
/// Function response.
class GeneratedReport {
  const GeneratedReport({required this.sections, this.summary});

  final String? summary;
  final List<GeneratedReportSection> sections;

  static GeneratedReport fromMap(Map<String, dynamic> m) => GeneratedReport(
        summary: m['summary'] as String?,
        sections: ((m['sections'] as List?) ?? const []).map((e) => GeneratedReportSection.fromMap(Map<String, dynamic>.from(e as Map))).toList(),
      );
}

/// Claude-backed dynamic module content. **Every method returns null on any
/// failure** (function not deployed, network, model error, bad JSON) — callers
/// must fall back to the built-in static content so the app never breaks.
/// See `functions/ai.js` for `generateModule1Questions` / `generateInsight` /
/// `generateCareerPlan` / `generateFinalReport`.
@lazySingleton
class AiContentRepository {
  AiContentRepository(this._functions);

  final FirebaseFunctions _functions;

  Future<List<GeneratedQuestion>?> module1Questions({String? ageBracket}) async {
    try {
      final callable = _functions.httpsCallable(
        'generateModule1Questions',
        options: HttpsCallableOptions(timeout: _callTimeout),
      );
      final result = await callable.call<Map<String, dynamic>>({
        if (ageBracket != null) 'ageBracket': ageBracket,
      });
      final raw = (result.data['questions'] as List?) ?? const [];
      final questions =
          raw.map((e) => GeneratedQuestion.fromMap(Map<String, dynamic>.from(e as Map))).toList();
      return questions.length == 3 ? questions : null;
    } catch (_) {
      return null;
    }
  }

  Future<GeneratedInsight?> insight({
    required String scope,
    required List<Map<String, dynamic>> answers,
  }) async {
    if (answers.isEmpty) return null;
    try {
      final callable = _functions.httpsCallable(
        'generateInsight',
        options: HttpsCallableOptions(timeout: _callTimeout),
      );
      final result = await callable.call<Map<String, dynamic>>({
        'scope': scope,
        'answers': answers,
      });
      final insight = GeneratedInsight.fromMap(result.data);
      return insight.items.isEmpty ? null : insight;
    } catch (_) {
      return null;
    }
  }

  Future<GeneratedCareerPlan?> careerPlan({required List<Map<String, dynamic>> answers}) async {
    if (answers.isEmpty) return null;
    try {
      final callable = _functions.httpsCallable('generateCareerPlan', options: HttpsCallableOptions(timeout: _callTimeout));
      final result = await callable.call<Map<String, dynamic>>({'answers': answers});
      final plan = GeneratedCareerPlan.fromMap(result.data);
      return plan.directions.isEmpty ? null : plan;
    } catch (_) {
      return null;
    }
  }

  Future<GeneratedReport?> finalReport({required List<Map<String, dynamic>> answers}) async {
    if (answers.isEmpty) return null;
    try {
      final callable = _functions.httpsCallable('generateFinalReport', options: HttpsCallableOptions(timeout: _callTimeout));
      final result = await callable.call<Map<String, dynamic>>({'answers': answers});
      final report = GeneratedReport.fromMap(result.data);
      return report.sections.isEmpty ? null : report;
    } catch (_) {
      return null;
    }
  }
}
