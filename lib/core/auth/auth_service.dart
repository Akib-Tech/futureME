import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthService {
  AuthService(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() => _firebaseAuth.signOut();
}

/// Maps [FirebaseAuthException] codes to Romanian, user-facing messages.
String authErrorMessage(FirebaseAuthException e) {
  switch (e.code) {
    case 'invalid-email':
      return 'Adresa de email nu este validă.';
    case 'email-already-in-use':
      return 'Există deja un cont cu acest email.';
    case 'weak-password':
      return 'Parola este prea slabă. Alege una cu cel puțin 6 caractere.';
    case 'user-not-found':
      return 'Nu există niciun cont cu acest email.';
    case 'wrong-password':
    case 'invalid-credential':
      return 'Email sau parolă incorectă.';
    case 'user-disabled':
      return 'Acest cont a fost dezactivat.';
    case 'too-many-requests':
      return 'Prea multe încercări. Te rugăm să încerci mai târziu.';
    case 'network-request-failed':
      return 'Verifică-ți conexiunea la internet și încearcă din nou.';
    default:
      return 'A apărut o eroare. Te rugăm să încerci din nou.';
  }
}
