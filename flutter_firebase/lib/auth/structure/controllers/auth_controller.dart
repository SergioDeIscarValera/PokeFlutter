import 'package:PokeFlutter/auth/services/auth_firebase_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordAgainController = TextEditingController();
  Rxn<User?> firebaseUser = Rxn<User?>();

  registerWithEmailAndPassword({Function? onSuccess, Function? onFail}) async {
    firebaseUser.value = await AuthFirebaseRepository()
        .registerWithEmailAndPassword(
            email: emailController.value.text,
            password: passwordController.value.text);
    if (firebaseUser.value != null) {
      onSuccess?.call();
    } else {
      onFail?.call();
    }
  }

  loginWithEmailAndPassword({Function? onSuccess, Function? onFail}) async {
    firebaseUser.value = await AuthFirebaseRepository()
        .loginWithEmailAndPassword(
            email: emailController.value.text,
            password: passwordController.value.text);
    if (firebaseUser.value != null) {
      onSuccess?.call();
    } else {
      onFail?.call();
    }
  }

  loginWithGoogle({Function? onSuccess, Function? onFail}) async {
    firebaseUser.value = await AuthFirebaseRepository().loginWithGoogle();
    if (firebaseUser.value != null) {
      onSuccess?.call();
    } else {
      onFail?.call();
    }
  }

  signOut({Function? onSingOut}) {
    firebaseUser.value = null;
    onSingOut?.call();
  }
}
