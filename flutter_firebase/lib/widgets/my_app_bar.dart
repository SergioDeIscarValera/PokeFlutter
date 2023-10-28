import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({
    super.key,
    required this.userName,
    required this.leftIcon,
    required this.rightIcon,
    required this.leftFuntion,
    required this.rightFuntion,
    required this.textTap,
  });

  final IconData leftIcon;
  final IconData rightIcon;
  final Function leftFuntion;
  final Function rightFuntion;
  final Function textTap;
  final String? userName;

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
                rightFuntion.call();
              },
              icon: Icon(rightIcon),
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
                    userName ?? "Anonymous",
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
