import 'package:PokeFlutter/auth/structure/controllers/auth_controller.dart';
import 'package:PokeFlutter/pokemon/structure/controllers/user_favorites_controller.dart';
import 'package:PokeFlutter/pokemon/widgets/grid_of_pokemons.dart';
import 'package:PokeFlutter/widgets/my_app_bar.dart';
import 'package:PokeFlutter/widgets/user_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PokemonFavorites extends StatelessWidget {
  PokemonFavorites({Key? key}) : super(key: key);

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find();
    UserFavoritesController userFavoritesController = Get.find();

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(children: [
            Builder(
              builder: (context) => MyAppBar(
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
                textTap: () {
                  Get.snackbar(
                    "Favorites",
                    "You have ${userFavoritesController.favorites.length} favorites",
                    backgroundColor: Colors.grey[700],
                    colorText: Colors.white,
                  );
                },
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    GridOfPokemons(
                      pokemonList: userFavoritesController.favorites,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      crossAxisCount: 2,
                    )
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
      endDrawer: UserDrawer(
        userName: authController.firebaseUser?.displayName ?? "Anonymous",
      ),
    );
  }
}
