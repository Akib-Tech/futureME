import 'package:flutter/material.dart';
import 'package:futureme/core/auth/auth_service.dart';
import 'package:futureme/core/data/ai_content_repository.dart';
import 'package:futureme/core/data/module_progress_repository.dart';
import 'package:futureme/core/di/injectable_init.dart';
import 'package:futureme/feature/dashboard/templates/module_feedback_summary_screen.dart';
import 'package:futureme/feature/dashboard/templates/module_final_feedback_screen.dart';
import 'package:futureme/feature/dashboard/templates/module_loading_screen.dart';

const List<IconData> _insightIcons = [
  Icons.wb_sunny_outlined,
  Icons.psychology_outlined,
  Icons.explore_outlined,
  Icons.balance_outlined,
  Icons.bolt_outlined,
  Icons.handshake_outlined,
];

SummaryLevel? _toSummaryLevel(InsightLevel? level) => switch (level) {
      InsightLevel.low => SummaryLevel.low,
      InsightLevel.medium => SummaryLevel.medium,
      InsightLevel.high => SummaryLevel.high,
      null => null,
    };

/// Maps a Claude-generated [GeneratedInsight] to the [SummaryItem] list the
/// feedback screens render.
List<SummaryItem> insightToSummaryItems(GeneratedInsight insight) => [
      for (int i = 0; i < insight.items.length; i++)
        SummaryItem(
          icon: _insightIcons[i % _insightIcons.length],
          title: insight.items[i].title,
          description: insight.items[i].description,
          level: _toSummaryLevel(insight.items[i].level),
        ),
    ];

/// Maps a Claude-generated [GeneratedInsight] to the [ConnectionItem] list
/// the module "Final Feedback" synthesis screens render.
List<ConnectionItem> insightToConnectionItems(GeneratedInsight insight) => [
      for (int i = 0; i < insight.items.length; i++)
        ConnectionItem(
          icon: _insightIcons[i % _insightIcons.length],
          title: insight.items[i].title,
          description: insight.items[i].description,
        ),
    ];

/// Loading gate: reads the user's saved answers for [scope] / [moduleId]
/// (optionally a single [stage]), asks the `generateInsight` Cloud Function
/// for a per-user interpretation, then replaces itself with
/// `builder(context, insight)`.
///
/// `insight` is **null** whenever the function is unavailable, offline, or
/// errors — the builder must render the screen's fixed fallback content in
/// that case, so the flow never breaks.
class InsightFeedbackGate extends StatefulWidget {
  const InsightFeedbackGate({
    super.key,
    required this.scope,
    required this.moduleId,
    required this.builder,
    this.stage,
    this.alsoFromModules,
    this.loadingLabel = "Feedback",
  });

  final String scope;
  final String moduleId;
  final int? stage;

  /// Extra module ids whose saved answers are merged in alongside
  /// [moduleId]'s — used by the Module 5 synthesis screens, which have no
  /// questions of their own and interpret the whole journey.
  final List<String>? alsoFromModules;

  final String loadingLabel;
  final Widget Function(BuildContext context, GeneratedInsight? insight) builder;

  @override
  State<InsightFeedbackGate> createState() => _InsightFeedbackGateState();
}

class _InsightFeedbackGateState extends State<InsightFeedbackGate> {
  @override
  void initState() {
    super.initState();
    _resolve();
  }

  Future<void> _resolve() async {
    GeneratedInsight? insight;
    final uid = getIt<AuthService>().currentUser?.uid;
    if (uid != null) {
      try {
        final repo = getIt<ModuleProgressRepository>();
        final answers = await repo.fetchAnswers(uid, widget.moduleId, stage: widget.stage);
        for (final extraModuleId in widget.alsoFromModules ?? const <String>[]) {
          answers.addAll(await repo.fetchAnswers(uid, extraModuleId));
        }
        if (answers.isNotEmpty) {
          insight = await getIt<AiContentRepository>().insight(scope: widget.scope, answers: answers);
        }
      } catch (_) {
        insight = null;
      }
    }
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => widget.builder(context, insight)),
    );
  }

  @override
  Widget build(BuildContext context) => ModuleLoadingScreen(
        moduleLabel: widget.loadingLabel,
        title: "Pregătim feedbackul tău",
        description: "Ne uităm peste răspunsurile tale. Durează câteva secunde.",
        reminderText: "Acesta este un reper, nu o etichetă.",
      );
}
