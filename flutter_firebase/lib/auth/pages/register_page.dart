import 'package:PokeFlutter/auth/structure/controllers/auth_controller.dart';
import 'package:PokeFlutter/auth/utils/validators_utils.dart';
import 'package:PokeFlutter/auth/widgets/button_modern.dart';
import 'package:PokeFlutter/auth/widgets/square_tile.dart';
import 'package:PokeFlutter/auth/widgets/text_field_modern.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    FormValidator formValidator = FormValidator();
    AuthController authController = Get.find();
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 25),

                    // Logo
                    const Icon(
                      Icons.lock,
                      size: 100,
                    ),

                    const SizedBox(height: 25),

                    // welcome back

                    Text(
                      "Sing Up!",
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // email textfield
                    TextFieldModern(
                      controller: authController.emailController,
                      validator: formValidator.isValidEmail,
                      hint: "Email...",
                    ),

                    const SizedBox(height: 10),

                    // password textfield
                    TextFieldModern(
                      obscureText: true,
                      controller: authController.passwordController,
                      validator: formValidator.isValidPass,
                      hint: "Password...",
                    ),

                    const SizedBox(height: 10),

                    // password again textfield
                    TextFieldModern(
                      obscureText: true,
                      controller: authController.passwordAgainController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Password again is required";
                        }
                        if (val != authController.passwordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                      hint: "Password again...",
                    ),

                    const SizedBox(height: 25),

                    // sing in button
                    ButtonModern(
                      text: "Sing Up",
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          authController.registerWithEmailAndPassword(
                              onSuccess: Get.back);
                        }
                      },
                    ),

                    const SizedBox(height: 50),

                    // or continue with
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey[600],
                              thickness: 0.5,
                            ),
                          ),
                          Text("  Or continue with  ",
                              style: TextStyle(
                                color: Colors.grey[700],
                              )),
                          Expanded(
                            child: Divider(
                              color: Colors.grey[600],
                              thickness: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // google button

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SquareTile(
                          imagePath: "lib/assets/google.png",
                          onTap: () {
                            authController.loginWithGoogle();
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 50),

                    // not remember password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Member?",
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
