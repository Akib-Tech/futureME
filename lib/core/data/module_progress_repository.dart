import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

/// Owns `users/{uid}/moduleProgress/{moduleId}` and its `answers`
/// subcollection. `moduleId` is `'module1'`..`'module5'`.
@lazySingleton
class ModuleProgressRepository {
  ModuleProgressRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _moduleProgressCollection(String uid) =>
      _firestore.collection('users').doc(uid).collection('moduleProgress');

  DocumentReference<Map<String, dynamic>> _moduleDoc(String uid, String moduleId) =>
      _moduleProgressCollection(uid).doc(moduleId);

  Future<void> markStarted(String uid, String moduleId) {
    return _moduleDoc(uid, moduleId).set({
      'status': 'in_progress',
      'startedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> markCompleted(String uid, String moduleId) {
    return _moduleDoc(uid, moduleId).set({
      'status': 'completed',
      'completedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Returns how many of module1..module5 have `status: 'completed'`, used
  /// to hydrate the in-memory [ModuleProgress] counter on dashboard load.
  Future<int> fetchCompletedCount(String uid) async {
    final snapshot = await _moduleProgressCollection(uid).where('status', isEqualTo: 'completed').get();
    return snapshot.docs.length;
  }

  /// All saved answers for a module (optionally filtered to one `stage`),
  /// shaped for the `generateInsight` Cloud Function — the `updatedAt`
  /// server timestamp is dropped since it doesn't round-trip through JSON.
  Future<List<Map<String, dynamic>>> fetchAnswers(String uid, String moduleId, {int? stage}) async {
    Query<Map<String, dynamic>> query = _moduleDoc(uid, moduleId).collection('answers');
    if (stage != null) query = query.where('stage', isEqualTo: stage);
    final snapshot = await query.get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return <String, dynamic>{
        'questionKey': doc.id,
        'type': data['type'],
        'value': data['value'],
        if (data['stage'] != null) 'stage': data['stage'],
        if (data['questionNumber'] != null) 'questionNumber': data['questionNumber'],
      };
    }).toList();
  }

  Future<void> saveAnswer(
    String uid,
    String moduleId,
    String questionKey, {
    required String type,
    required Object value,
    int? stage,
    int? questionNumber,
  }) {
    return _moduleDoc(uid, moduleId).collection('answers').doc(questionKey).set({
      'type': type,
      'value': value,
      if (stage != null) 'stage': stage,
      if (questionNumber != null) 'questionNumber': questionNumber,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Resets all module statuses back to `'locked'` for a retake. Answer
  /// history under each module is left in place rather than deleted.
  Future<void> resetAll(String uid) async {
    final batch = _firestore.batch();
    for (var i = 1; i <= 5; i++) {
      batch.set(_moduleDoc(uid, 'module$i'), {'status': 'locked'}, SetOptions(merge: true));
    }
    await batch.commit();
  }
}
