import 'package:PokeFlutter/auth/services/auth_firebase_repository.dart';
import 'package:PokeFlutter/auth/structure/controllers/auth_controller.dart';
import 'package:PokeFlutter/teams/models/team_dto.dart';
import 'package:PokeFlutter/teams/models/team_permissions.dart';
import 'package:PokeFlutter/teams/services/teams_firebase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeamsPreviewController extends GetxController {
  RxList<TeamDto> teams = <TeamDto>[].obs;
  final String? _emailUser = Get.find<AuthController>().firebaseUser?.email;

  TextEditingController teamNameController = TextEditingController();

  TextEditingController emailController = TextEditingController();
  Rx<TeamPermissions> teamPermissions = TeamPermissions.read.obs;

  @override
  void onReady() {
    if (_emailUser != null) {
      refeshTeams(emailUser: _emailUser!);
      TeamsFirebase().setListeneOwner(
          email: _emailUser!,
          callback: (newList) {
            teams.value = newList;
          });
    }
    super.onReady();
  }

  Future<void> refeshTeams({required String emailUser}) async {
    teams.value = [];
    teams.value = await TeamsFirebase().getTeams(email: emailUser);
  }

  void createNewTeam() async {
    if (_emailUser == null) return;
    await TeamsFirebase().createTeam(
      email: _emailUser!,
      team: TeamDto(
          UUID: "-1",
          owner: _emailUser,
          name: teamNameController.text.trim(),
          pokemons: [],
          users: {}),
    );
  }

  void deleteTeam({required String uuid}) async {
    await TeamsFirebase().deleteTeam(email: _emailUser!, uuid: uuid);
  }

  void shareTeam(
      {required String teamUuid,
      required String teamName,
      required Function callback}) async {
    var email = emailController.text.trim().toLowerCase();
    if (!await AuthFirebaseRepository().isEmailAlreadyRegistered(email)) {
      Get.snackbar(
        "Error",
        "Email not registered",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (_emailUser == email) {
      Get.snackbar(
        "Error",
        "You can't share a team with yourself ( ͡° ͜ʖ ͡° )",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    await TeamsFirebase().sendInvitation(
      emailSender: _emailUser!,
      emailReceiver: email,
      teamUuid: teamUuid,
      teamName: teamName,
      permission: TeamPermissionsUtils(teamPermissions.value).permission,
    );

    callback();
  }
}
