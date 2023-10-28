import 'package:PokeFlutter/pokemon/models/pokemon_dto.dart';
import 'package:PokeFlutter/pokemon/models/pokemon_type.dart';
import 'package:PokeFlutter/teams/structure/controllers/teams_edit_controller.dart';
import 'package:PokeFlutter/teams/widgets/item_of_moveset.dart';
import 'package:PokeFlutter/teams/widgets/newCard_card.dart';
import 'package:PokeFlutter/utils/string_funtions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListOfMoveset extends StatelessWidget {
  const ListOfMoveset({
    super.key,
    required this.teamsEditController,
    required this.emailUser,
    required this.emailOwner,
    required this.uuidTeam,
  });

  final TeamsEditController teamsEditController;
  final String emailUser;
  final String emailOwner;
  final String uuidTeam;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (teamsEditController.team.isNotEmpty) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey[600],
          ),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(5),
          child: Column(
            children: [
              const Text(
                "Movesets:",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: teamsEditController.team.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.grey[300],
                    ),
                    // Margin bottom except last element
                    margin: EdgeInsets.only(
                      bottom:
                          index == teamsEditController.team.length - 1 ? 0 : 15,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Stack(children: [
                      Positioned(
                        top: 0,
                        right: 0,
                        bottom: 0,
                        left: 0,
                        child: Image.network(
                          teamsEditController.team.keys.toList()[index].image!,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error),
                          // Filtro de color oscuro
                          color: teamsEditController.team.keys
                              .toList()[index]
                              .type!
                              .color
                              .withOpacity(0.15),
                          repeat: ImageRepeat.repeat,
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            "${StringFunctions.capitalize(teamsEditController.team.keys.toList()[index].name!)}:",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: teamsEditController.team.keys
                                      .toList()[index]
                                      .type
                                      ?.color ??
                                  Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          GridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: (1.85 / 1),
                            children: [
                              for (int i = 0;
                                  i <
                                      teamsEditController.team.values
                                          .toList()[index]
                                          .length;
                                  i++)
                                ItemOfMoveset(
                                  teamsEditController: teamsEditController,
                                  index: index,
                                  i: i,
                                  emailOwner: emailOwner,
                                  emailUser: emailUser,
                                  uuidTeam: uuidTeam,
                                ),
                              for (int i = teamsEditController.team.values
                                      .toList()[index]
                                      .length;
                                  i < 4;
                                  i++)
                                Container(
                                  color: Colors.grey[300]!.withOpacity(0.65),
                                  child: NewCardCard(onTap: () {
                                    if (emailOwner != emailUser &&
                                        !teamsEditController
                                            .teamPermissions[emailUser]!) {
                                      Get.snackbar("Error",
                                          "You can't edit pokemons to this team");
                                      return;
                                    }
                                    opneMoveDialog(
                                      context: context,
                                      teamsEditController: teamsEditController,
                                      email: emailOwner,
                                      uuidTeam: uuidTeam,
                                      pokemon: teamsEditController.team.keys
                                          .toList()[index],
                                    );
                                  }),
                                )
                            ],
                          ),
                        ],
                      ),
                    ]),
                  );
                },
              ),
            ],
          ),
        );
      } else {
        return const SizedBox();
      }
    });
  }

  Future opneMoveDialog({
    required BuildContext context,
    required TeamsEditController teamsEditController,
    required PokemonDto pokemon,
    required String email,
    required String uuidTeam,
  }) =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                pokemon.name!.toUpperCase(),
                style: TextStyle(
                  color: pokemon.type!.color.withOpacity(0.5),
                  fontSize: 14,
                  //Espaciado entre letras
                  letterSpacing: 6,
                ),
              ),
              const Text(
                "Select a move",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
              const SizedBox(height: 10),
              const Divider(
                color: Colors.black,
              ),
              Text(
                "Tap on a move to add it to the moveset",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black.withOpacity(0.5), fontSize: 12),
              )
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.grey[300],
          content: Obx(() {
            List<String> moves =
                (teamsEditController.allMoves[pokemon.id] ?? [])
                    .map((e) => StringFunctions.capitalize(e))
                    .toList();
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[600],
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (moves.isEmpty)
                      const CircularProgressIndicator()
                    else
                      for (var item in moves)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: pokemon.type!.color,
                          ),
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            onTap: () {
                              teamsEditController.moveToAdd.value = item;
                              teamsEditController.addMove(
                                email: email,
                                uuidTeam: uuidTeam,
                                pokemon: pokemon,
                              );
                              Get.back();
                            },
                            title: Text(
                              item,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                  ],
                ),
              ),
            );
          }),
          actions: [
            Tooltip(
              message: "Cancel",
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.cancel),
              ),
            )
          ],
        ),
      );
}
