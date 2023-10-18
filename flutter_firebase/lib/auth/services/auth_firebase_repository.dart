import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthFirebaseRepository {
  Future<User?> registerWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User?> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User?> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((UserCredential userCredential) {
        User? user = userCredential.user;

        return user;
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User?> signInAnonymous() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      User? user = userCredential.user;
      return user;
    } on FirebaseAuthException catch (_) {
      return null;
    }
  }
}
