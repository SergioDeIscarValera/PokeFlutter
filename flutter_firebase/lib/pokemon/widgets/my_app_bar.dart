import 'package:PokeFlutter/auth/structure/controllers/auth_controller.dart';
import 'package:PokeFlutter/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({
    super.key,
    required this.authController,
    required this.leftIcon,
    required this.leftFuntion,
    required this.textTap,
  });

  final IconData leftIcon;
  final Function leftFuntion;
  final AuthController authController;
  final Function textTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                authController.signOut(
                  onSingOut: () => Get.offAllNamed(Routes.LOGIN),
                );
              },
              icon: const Icon(Icons.logout),
            ),
            GestureDetector(
              onTap: () {
                textTap.call();
              },
              child: Column(
                children: [
                  Text(
                    "PokeFlutter",
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    authController.firebaseUser?.email ?? "Anonymous",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 8,
                    ),
                  )
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                //Get.toNamed(Routes.POKEMON_FAVORITES);
                leftFuntion.call();
              },
              icon: Icon(leftIcon),
            ),
          ],
        ),
      ),
    );
  }
}
