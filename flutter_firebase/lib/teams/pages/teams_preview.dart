import 'package:PokeFlutter/auth/structure/controllers/auth_controller.dart';
import 'package:PokeFlutter/widgets/my_app_bar.dart';
import 'package:PokeFlutter/teams/structure/controllers/teams_preview_controller.dart';
import 'package:PokeFlutter/teams/widgets/newCard_card.dart';
import 'package:PokeFlutter/teams/widgets/team_card.dart';
import 'package:PokeFlutter/widgets/user_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeamsPreview extends StatelessWidget {
  TeamsPreview({Key? key}) : super(key: key);

  final AuthController authController = Get.find();
  final TeamsPreviewController teamsPreviewController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Builder(builder: (context) {
                return MyAppBar(
                  rightFuntion: () {
                    Get.back();
                  },
                  userName:
                      authController.firebaseUser?.displayName ?? "Anonymous",
                  rightIcon: Icons.arrow_back_ios_new,
                  leftIcon: Icons.person,
                  leftFuntion: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  textTap: () {},
                );
              }),
              const SizedBox(height: 15),
              Expanded(
                child: Obx(
                  () {
                    return GridView.count(
                      crossAxisCount: 2,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 15,
                      shrinkWrap: true,
                      childAspectRatio: (1.25 / 1), // (1.85 / 1)
                      children: [
                        ...teamsPreviewController.teams.value.map((team) {
                          return TeamCard(
                            team: team,
                            email: authController.firebaseUser?.email ?? "",
                            teamsPreviewController: teamsPreviewController,
                          );
                        }).toList(),
                        NewCardCard(
                          onTap: () {
                            openNewTeamDialog(
                              context,
                              teamsPreviewController.teamNameController,
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      endDrawer: UserDrawer(
        userName: authController.firebaseUser?.displayName ?? "Anonymous",
      ),
    );
  }

  Future openNewTeamDialog(
          BuildContext context, TextEditingController controller) =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("New Team"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: "Write team name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            controller: controller,
          ),
          actions: [
            IconButton(
              onPressed: () {
                Get.back();
                controller.clear();
              },
              icon: Icon(
                Icons.cancel,
                color: Colors.grey[700],
              ),
            ),
            IconButton(
              onPressed: () {
                if (controller.text.trim().isEmpty) {
                  Get.snackbar("Error", "Team name is empty");
                  return;
                }
                if (controller.text.trim().length > 15) {
                  Get.snackbar("Error", "Team name is too long");
                  return;
                }
                Get.back();
                teamsPreviewController.createNewTeam();
                controller.clear();
              },
              icon: Icon(
                Icons.check_circle,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      );
}
