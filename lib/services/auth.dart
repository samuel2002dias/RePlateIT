import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? currentUser() => _firebaseAuth.currentUser;

  get authStateChanges => _firebaseAuth.authStateChanges();

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> register({
    required String email,
    required String password,
  }) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  // Future<void> changePassword(String newPassword) async {
  //   if (_firebaseAuth.currentUser?.email != null) {
  //     _firebaseAuth.sendPasswordResetEmail(
  //         email: _firebaseAuth.currentUser!.email ?? "");
  //   }
  // }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
