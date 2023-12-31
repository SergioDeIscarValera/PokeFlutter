import 'package:PokeFlutter/auth/structure/controllers/auth_controller.dart';
import 'package:PokeFlutter/pokemon/structure/controllers/pokemon_controller.dart';
import 'package:PokeFlutter/pokemon/structure/controllers/search_filter_controller.dart';
import 'package:PokeFlutter/pokemon/structure/controllers/user_favorites_controller.dart';
import 'package:PokeFlutter/pokemon/widgets/grid_of_pokemons.dart';
import 'package:PokeFlutter/widgets/my_app_bar.dart';
import 'package:PokeFlutter/pokemon/widgets/pokemon_search_bar.dart';
import 'package:PokeFlutter/widgets/user_drawer.dart';
import 'package:PokeFlutter/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PokemonHome extends StatelessWidget {
  PokemonHome({Key? key}) : super(key: key);

  final ScrollController _scrollController = ScrollController();

  final int pagination = 10;

  @override
  Widget build(BuildContext context) {
    PokemonController pokemonController = Get.find();
    pokemonController.setPaginarion(pagination);

    AuthController authController = Get.find();
    UserFavoritesController userFavoritesController = Get.find();
    SearchFilterController searchFilterController = Get.find();

    var userEmail = authController.firebaseUser?.email ?? "Anonymous";
    if (pokemonController.pokemonList.isEmpty) {
      pokemonController.getPokemonList(offset: 0, limit: pagination);
    }
    userFavoritesController.refreshFavorites(
        email: userEmail, pokemonController: pokemonController);

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    height: 90,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(16),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Center(
                        child: MySearch(
                          pokemons: pokemonController.pokemonList,
                          searchController:
                              searchFilterController.searchController,
                          statsRangeValues:
                              searchFilterController.statsRangeValues,
                          typeFilter: searchFilterController.typeFilter,
                          subTypeFilter: searchFilterController.subTypeFilter,
                          generationFilter:
                              searchFilterController.generationFilter,
                          moreFilterIsOpen:
                              searchFilterController.moreFilterIsOpen,
                          changeMoreFilterIsOpen:
                              searchFilterController.changeMoreFilterIsOpen,
                          resetStatsRangeValues:
                              searchFilterController.resetStatsRangeValues,
                        ),
                      ),
                    ),
                  ),
                  // AppBar
                  Builder(
                    builder: (context) => MyAppBar(
                      rightFuntion: () {
                        //Dialogo de confirmación
                        Get.defaultDialog(
                          title: "Sign Out",
                          middleText: "Are you sure?",
                          textConfirm: "Yes",
                          textCancel: "No",
                          confirmTextColor: Colors.white,
                          onConfirm: () {
                            authController.signOut();
                          },
                          onCancel: () {
                            Get.back();
                          },
                        );
                      },
                      userName: authController.firebaseUser?.displayName ??
                          "Anonymous",
                      rightIcon: Icons.logout,
                      leftIcon: Icons.person,
                      leftFuntion: () {
                        Scaffold.of(context).openEndDrawer();
                      },
                      textTap: () {
                        pokemonController.resetPokemonList();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              // Grid Pokemons
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      GridOfPokemons(
                        pokemonList: pokemonController.pokemonList,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        crossAxisCount: 2,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: () {
                              pokemonController.getPreviousPokemonList();
                              _scrollController.jumpTo(
                                  _scrollController.position.minScrollExtent);
                            },
                            icon: const Icon(Icons.arrow_back_ios),
                          ),
                          IconButton(
                            onPressed: () {
                              pokemonController.resetPokemonList();
                            },
                            icon: const Icon(Icons.restart_alt),
                          ),
                          IconButton(
                            onPressed: () {
                              pokemonController.getNextPokemonList();
                              _scrollController.jumpTo(
                                  _scrollController.position.minScrollExtent);
                            },
                            icon: const Icon(Icons.arrow_forward_ios),
                          ),
                        ],
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
}
