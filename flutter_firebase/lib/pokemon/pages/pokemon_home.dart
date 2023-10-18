import 'package:PokeFlutter/auth/structure/controllers/auth_controller.dart';
import 'package:PokeFlutter/pokemon/structure/controllers/pokemon_controller.dart';
import 'package:PokeFlutter/pokemon/structure/controllers/search_filter_controller.dart';
import 'package:PokeFlutter/pokemon/structure/controllers/user_favorites_controller.dart';
import 'package:PokeFlutter/pokemon/widgets/grid_of_pokemons.dart';
import 'package:PokeFlutter/pokemon/widgets/my_app_bar.dart';
import 'package:PokeFlutter/pokemon/widgets/pokemon_search_bar.dart';
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
                          bottom: Radius.circular(16)),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Center(
                        child: MySearch(),
                      ),
                    ),
                  ),
                  // AppBar
                  MyAppBar(
                    authController: authController,
                    leftIcon: Icons.person,
                    leftFuntion: () {
                      Get.toNamed(Routes.POKEMON_FAVORITES);
                    },
                    textTap: () {
                      pokemonController.resetPokemonList();
                    },
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
                      Obx(() {
                        if (!searchFilterController.isFiltering) {
                          return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    pokemonController.getPreviousPokemonList();
                                    _scrollController.jumpTo(_scrollController
                                        .position.minScrollExtent);
                                  },
                                  icon: const Icon(Icons.arrow_back_ios),
                                ),
                                IconButton(
                                  onPressed: () {
                                    pokemonController.getNextPokemonList();
                                    _scrollController.jumpTo(_scrollController
                                        .position.minScrollExtent);
                                  },
                                  icon: const Icon(Icons.arrow_forward_ios),
                                ),
                              ]);
                        } else {
                          return const SizedBox();
                        }
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
