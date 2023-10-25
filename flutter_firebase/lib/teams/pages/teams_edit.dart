import 'package:PokeFlutter/auth/structure/controllers/auth_controller.dart';
import 'package:PokeFlutter/pokemon/models/pokemon_dto.dart';
import 'package:PokeFlutter/pokemon/structure/controllers/pokemon_controller.dart';
import 'package:PokeFlutter/pokemon/widgets/grid_of_pokemons.dart';
import 'package:PokeFlutter/pokemon/widgets/my_app_bar.dart';
import 'package:PokeFlutter/pokemon/widgets/pokemon_search_bar.dart';
import 'package:PokeFlutter/teams/models/team_dto.dart';
import 'package:PokeFlutter/teams/models/team_permissions.dart';
import 'package:PokeFlutter/teams/structure/controllers/teams_edit_controller.dart';
import 'package:PokeFlutter/teams/widgets/list_of_users.dart';
import 'package:PokeFlutter/teams/widgets/newCard_card.dart';
import 'package:PokeFlutter/widgets/user_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeamsEdit extends StatelessWidget {
  TeamsEdit({Key? key}) : super(key: key);

  final AuthController authController = Get.find();
  final TeamsEditController teamsEditController = Get.find();
  final PokemonController pokemonController = Get.find();

  @override
  Widget build(BuildContext context) {
    final String? thisUserEmail = authController.firebaseUser?.email;
    TeamDto argumentTeam = Get.arguments != null
        ? Get.arguments["team"]
        : TeamDto(
            UUID: "",
            owner: "",
            name: "",
            pokemons: [],
            users: {},
          );
    teamsEditController.setListeners(argumentTeam, argumentTeam.owner!);
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      Text(
                        argumentTeam.name ?? "",
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        argumentTeam.owner ?? "",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 25),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Obx(
                              () => GridOfPokemons(
                                pokemonList: teamsEditController.team,
                                mainAxisSpacing: 15,
                                crossAxisSpacing: 15,
                                crossAxisCount: 2,
                                progressIndicator: false,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                icon: Icons.delete,
                                iconSecondary: Icons.delete,
                                iconSecondaryColor: Colors.white,
                                checkPokemon: (_) =>
                                    true, // No hay que comprobar nada
                                onCardTap: ({required pokemon}) {
                                  if (argumentTeam.owner != thisUserEmail &&
                                      !teamsEditController
                                          .teamPermissions[thisUserEmail]!) {
                                    Get.snackbar("Error",
                                        "You can't edit pokemons to this team");
                                    return;
                                  }
                                  teamsEditController.removePokemon(
                                    argumentTeam.owner!,
                                    argumentTeam.UUID!,
                                    pokemon,
                                  );
                                },
                                otherWidgets: [
                                  for (int i = 0;
                                      i < (6 - teamsEditController.team.length);
                                      i++)
                                    NewCardCard(onTap: () {
                                      if (argumentTeam.owner != thisUserEmail &&
                                          !teamsEditController.teamPermissions[
                                              thisUserEmail]!) {
                                        Get.snackbar("Error",
                                            "You can't edit pokemons to this team");
                                        return;
                                      }
                                      openSelectPokemonDialog(
                                        context,
                                        argumentTeam.owner!,
                                        argumentTeam.UUID!,
                                        teamsEditController.team,
                                      );
                                    })
                                ],
                              ),
                            ),
                            if (argumentTeam.owner == thisUserEmail)
                              ListOfUsers(
                                users: teamsEditController.teamPermissions,
                                teamsEditController: teamsEditController,
                                team: argumentTeam,
                              )
                            else
                              const SizedBox(),
                          ],
                        ),
                      ),
                    ],
                  ),
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

  Future openSelectPokemonDialog(
    BuildContext context,
    String email,
    String uuidTeam,
    List<PokemonDto> team,
  ) =>
      showDialog(
        context: context,
        builder: (context) => Container(
          //padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                ),
                child: MySearch(
                  pokemons: pokemonController.pokemonList,
                  searchController: teamsEditController.searchController,
                  statsRangeValues: teamsEditController.statsRangeValues,
                  typeFilter: teamsEditController.typeFilter,
                  subTypeFilter: teamsEditController.subTypeFilter,
                  generationFilter: teamsEditController.generationFilter,
                  moreFilterIsOpen: teamsEditController.moreFilterIsOpen,
                  changeMoreFilterIsOpen:
                      teamsEditController.changeMoreFilterIsOpen,
                  resetStatsRangeValues:
                      teamsEditController.resetStatsRangeValues,
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      GridOfPokemons(
                        pokemonList: pokemonController.pokemonList,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        crossAxisCount: 2,
                        icon: Icons.add,
                        iconSecondary: Icons.add,
                        onCardTap: ({required pokemon}) {
                          if (team.contains(pokemon)) {
                            Get.snackbar(
                                "Error", "This pokemon is already in the team");
                            return;
                          }
                          teamsEditController.addPokemon(
                            email,
                            uuidTeam,
                            pokemon,
                          );
                          Get.back();
                        },
                        checkPokemon: (pokemon) {
                          return team.contains(pokemon);
                        },
                      ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.grey[600],
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
