import 'package:PokeFlutter/auth/structure/controllers/auth_controller.dart';
import 'package:PokeFlutter/teams/models/team_notification.dart';
import 'package:PokeFlutter/teams/services/teams_firebase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeamsNotificationsController extends GetxController {
  RxList<TeamNotification> notifications = <TeamNotification>[].obs;
  final String? _emailUser = Get.find<AuthController>().firebaseUser?.email;

  @override
  void onReady() {
    TeamsFirebase().setListenerNotifications(
        email: _emailUser!,
        callback: (newList) {
          notifications.value = newList;
        });
    super.onReady();
  }

  void acceptInvitation(int index) {
    TeamNotification teamNotification = notifications[index];
    TeamsFirebase().acceptInvitation(
      emailSender: teamNotification.inviter!,
      emailReciver: _emailUser!,
      teamUuid: teamNotification.uuidTeam!,
      onSucces: () {
        Get.snackbar("Success",
            "You are now part of the team ${teamNotification.nameTeam}",
            backgroundColor: Colors.green.withOpacity(0.2));
      },
    );
  }

  void declineInvitation(int index) {
    TeamNotification teamNotification = notifications[index];
    TeamsFirebase().declineInvitation(
      emailOwner: teamNotification.inviter!,
      emailReciver: _emailUser!,
      teamUuid: teamNotification.uuidTeam!,
      onSucces: () {
        Get.snackbar("Success",
            "You declined the invitation to the team ${teamNotification.nameTeam}",
            backgroundColor: Colors.white.withOpacity(0.2));
      },
    );
  }
}
