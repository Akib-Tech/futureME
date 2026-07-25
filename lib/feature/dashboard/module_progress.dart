/// In-memory progress tracker driving the Dashboard's 3 states (Figma
/// frames 61:271 "Start", 86:1433 "Module N Done", 496:2307 "Complete").
/// There's no backend/persistence layer in this app yet, so progress
/// resets on app restart — this only tracks state for the current
/// session.
class ModuleProgress {
  ModuleProgress._();

  /// How many of the 5 modules have been fully completed (0-5).
  static int completedModules = 0;

  static void markCompleted(int moduleNumber) {
    if (moduleNumber > completedModules) completedModules = moduleNumber;
  }

  static bool get isAllComplete => completedModules >= 5;
}
