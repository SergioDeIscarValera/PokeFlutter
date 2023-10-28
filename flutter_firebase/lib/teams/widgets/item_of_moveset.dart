import 'package:PokeFlutter/teams/structure/controllers/teams_edit_controller.dart';
import 'package:PokeFlutter/utils/string_funtions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemOfMoveset extends StatelessWidget {
  const ItemOfMoveset({
    super.key,
    required this.teamsEditController,
    required this.index,
    required this.i,
    required this.emailOwner,
    required this.emailUser,
    required this.uuidTeam,
  });

  final TeamsEditController teamsEditController;
  final int index;
  final int i;
  final String emailUser;
  final String emailOwner;
  final String uuidTeam;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[700]!.withOpacity(0.8),
        ),
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Text(
            StringFunctions.capitalize(
                teamsEditController.team.values.toList()[index][i]),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
      Positioned(
        right: 3,
        top: 3,
        child: GestureDetector(
          onTap: () {
            if (emailOwner != emailUser &&
                !teamsEditController.teamPermissions[emailUser]!) {
              Get.snackbar("Error", "You can't edit pokemons to this team");
              return;
            }
            teamsEditController.removeMove(
              email: emailOwner,
              uuidTeam: uuidTeam,
              pokemon: teamsEditController.team.keys.toList()[index],
              move: teamsEditController.team.values.toList()[index][i],
            );
          },
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.black.withOpacity(0.5),
            ),
            child: Icon(
              Icons.delete,
              color: Colors.grey[300],
            ),
          ),
        ),
      )
    ]);
  }
}
