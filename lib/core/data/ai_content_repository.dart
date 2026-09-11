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

/// Claude-backed dynamic module content. **Every method returns null on any
/// failure** (function not deployed, network, model error, bad JSON) — callers
/// must fall back to the built-in static content so the app never breaks.
/// See `functions/ai.js` for `generateModule1Questions` / `generateInsight`.
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
}
