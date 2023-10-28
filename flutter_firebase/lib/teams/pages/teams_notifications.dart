import 'package:PokeFlutter/auth/structure/controllers/auth_controller.dart';
import 'package:PokeFlutter/widgets/my_app_bar.dart';
import 'package:PokeFlutter/widgets/user_drawer.dart';
import 'package:PokeFlutter/teams/structure/controllers/teams_notifications_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeamsNotifications extends StatelessWidget {
  const TeamsNotifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find();
    TeamsNotificationsController teamsNotifiController = Get.find();
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
                  () => ListView.builder(
                    itemCount: teamsNotifiController.notifications.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.only(
                          bottom: 15,
                          left: 10,
                          right: 10,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: ListTile(
                                title: Text(
                                  teamsNotifiController
                                      .notifications[index].nameTeam!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                subtitle: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "From: ",
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                        ),
                                      ),
                                      TextSpan(
                                        text: teamsNotifiController
                                            .notifications[index].inviter!,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                teamsNotifiController.acceptInvitation(index);
                              },
                              icon: const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                teamsNotifiController.declineInvitation(index);
                              },
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      endDrawer: UserDrawer(
          userName: authController.firebaseUser?.displayName ?? "Anonymous"),
    );
  }
}
