import 'package:PokeFlutter/auth/structure/controllers/auth_controller.dart';
import 'package:PokeFlutter/auth/utils/validators_utils.dart';
import 'package:PokeFlutter/auth/widgets/button_modern.dart';
import 'package:PokeFlutter/auth/widgets/square_tile.dart';
import 'package:PokeFlutter/auth/widgets/text_field_modern.dart';
import 'package:PokeFlutter/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

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
                      "Welcome Back!",
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

                    //forgot password?
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // sing in button
                    ButtonModern(
                      text: "Login",
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          authController.loginWithEmailAndPassword();
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
                              color: Colors.grey[400],
                              thickness: 0.5,
                            ),
                          ),
                          Text("  Or continue with  ",
                              style: TextStyle(color: Colors.grey[700])),
                          Expanded(
                            child: Divider(
                              color: Colors.grey[400],
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
                          "Not a member?",
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.REGISTER);
                          },
                          child: const Text(
                            "Sign Up",
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
