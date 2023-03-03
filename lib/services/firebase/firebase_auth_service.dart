import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final  FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<User?> getUser() async {
    if (currentUser == null) {
      await _auth.signInAnonymously();
    }
    return currentUser;
  }
}