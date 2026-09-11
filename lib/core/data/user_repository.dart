import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:futureme/feature/authentication/pending_signup_data.dart';

/// Owns `users/{uid}` — the account profile doc. Onboarding data (age
/// bracket, consent, first name) is captured before the account exists, so
/// it's buffered in [PendingSignupData] and folded in here the moment a new
/// account is created (email/password signup or first social sign-in).
@lazySingleton
class UserRepository {
  UserRepository(this._firestore);

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) => _firestore.collection('users').doc(uid);

  Future<void> createOrUpdateProfileOnSignIn(User user, {required bool isNewUser}) async {
    final doc = _userDoc(user.uid);
    final now = FieldValue.serverTimestamp();

    if (!isNewUser) {
      await doc.set({'lastLoginAt': now}, SetOptions(merge: true));
      return;
    }

    final consentRequired = PendingSignupData.consentRequired;

    await doc.set({
      'uid': user.uid,
      'email': user.email,
      'displayName': PendingSignupData.firstName ?? user.displayName,
      'photoUrl': user.photoURL,
      'authProvider': user.providerData.isNotEmpty ? user.providerData.first.providerId : 'password',
      'createdAt': now,
      'updatedAt': now,
      'lastLoginAt': now,
      if (PendingSignupData.ageBracket != null) 'ageBracket': PendingSignupData.ageBracket,
      'consent': {
        'required': consentRequired,
        'status': !consentRequired
            ? 'not_required'
            : (PendingSignupData.consentConfirmedAt != null ? 'confirmed' : 'pending'),
        if (PendingSignupData.parentEmail != null) 'parentEmail': PendingSignupData.parentEmail,
        if (PendingSignupData.consentRequestedAt != null)
          'requestedAt': Timestamp.fromDate(PendingSignupData.consentRequestedAt!),
        if (PendingSignupData.consentConfirmedAt != null)
          'confirmedAt': Timestamp.fromDate(PendingSignupData.consentConfirmedAt!),
      },
      if (PendingSignupData.selfConsentAgreedAt != null)
        'selfConsentAgreedAt': Timestamp.fromDate(PendingSignupData.selfConsentAgreedAt!),
      'subscription': {'status': 'none'},
    }, SetOptions(merge: true));

    PendingSignupData.reset();
  }

  /// The raw `users/{uid}` profile document, or null if it doesn't exist yet.
  Future<Map<String, dynamic>?> fetchProfile(String uid) async {
    final snap = await _userDoc(uid).get();
    return snap.data();
  }

  /// The `users/{uid}/reports/finalReport` document written when Module 5
  /// finishes, or null if the journey isn't complete. `status` is
  /// `'not_generated'` until real report generation exists.
  Future<Map<String, dynamic>?> fetchFinalReport(String uid) async {
    final snap = await _userDoc(uid).collection('reports').doc('finalReport').get();
    return snap.data();
  }

  Future<void> updateDisplayName(String uid, String name) {
    return _userDoc(
      uid,
    ).set({'displayName': name, 'updatedAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
  }

  /// Records the plan the user picked on the pricing screen. This is a
  /// client-set flag only, not verified entitlement — real purchase
  /// validation needs RevenueCat + a server-side webhook (separate,
  /// already-tracked future work).
  Future<void> recordSubscriptionSelection(String uid, {required String plan}) {
    return _userDoc(uid).set({
      'subscription': {'status': 'active_unverified', 'plan': plan, 'selectedAt': FieldValue.serverTimestamp()},
    }, SetOptions(merge: true));
  }
}
