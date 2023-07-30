import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService{
  FirebaseAuth? _auth;

  FirebaseAuthService(){
    _auth = FirebaseAuth.instance;
  }

  Future<User?> getCurrentUser() async {
      return await _auth?.currentUser;
  }

  Future<UserCredential?> singUp(String email, String password) async {
    return await _auth?.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential?> singIn(String email, String password) async {
    return await _auth?.signInWithEmailAndPassword(
        email: email,
        password: password
    );
  }

  void signOut(){
    _auth?.signOut();
  }

  void resetPassword(String email) async {
    await _auth?.sendPasswordResetEmail(email: email);
  }
}