part of 'auth.dart';

class AuthController {
  final FirebaseAuth _auth;

  AuthController(this._auth);

  Stream<User> get authState => _auth.idTokenChanges();

  Future<UserCredential> signUp({String email, String password}) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw AuthException(message: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw AuthException(
          message: 'The account already exists for that email.',
        );
      }
      throw e;
    }
  }

  Future<UserCredential> signIn({String email, String password}) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  signOut() async => await _auth.signOut();

  signInAnon() async => await _auth.signInAnonymously();
}
