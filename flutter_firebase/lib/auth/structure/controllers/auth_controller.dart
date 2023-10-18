import 'package:PokeFlutter/auth/services/auth_firebase_repository.dart';
import 'package:PokeFlutter/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordAgainController = TextEditingController();
  final Rxn<User?> _firebaseUser = Rxn<User?>();
  User? get firebaseUser => _firebaseUser.value;
  set firebaseUser(User? newValue) => _firebaseUser.value = newValue;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<User?> get user => _auth.authStateChanges();

  @override
  void onReady() {
    ever(_firebaseUser, handleAuthChanged);
    _firebaseUser.bindStream(user);
    super.onReady();
  }

  signInAnonymous() async {
    firebaseUser = await AuthFirebaseRepository().signInAnonymous();
  }

  handleAuthChanged(User? firebaseUser) async {
    if (firebaseUser?.isAnonymous == false && firebaseUser?.uid != null ||
        firebaseUser?.isAnonymous == true) {
      Get.offAllNamed(Routes.POKEMON_HOME);
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  registerWithEmailAndPassword({Function? onSuccess, Function? onFail}) async {
    firebaseUser = await AuthFirebaseRepository().registerWithEmailAndPassword(
        email: emailController.value.text,
        password: passwordController.value.text);
    if (firebaseUser != null) {
      onSuccess?.call();
    } else {
      onFail?.call();
    }
  }

  loginWithEmailAndPassword({Function? onSuccess, Function? onFail}) async {
    firebaseUser = await AuthFirebaseRepository().loginWithEmailAndPassword(
        email: emailController.value.text,
        password: passwordController.value.text);
    if (firebaseUser != null) {
      onSuccess?.call();
    } else {
      onFail?.call();
    }
  }

  loginWithGoogle({Function? onSuccess, Function? onFail}) async {
    firebaseUser = await AuthFirebaseRepository().loginWithGoogle();
    if (firebaseUser != null) {
      onSuccess?.call();
    } else {
      onFail?.call();
    }
  }

  signOut({Function? onSingOut}) async {
    return await _auth.signOut();
  }
}
