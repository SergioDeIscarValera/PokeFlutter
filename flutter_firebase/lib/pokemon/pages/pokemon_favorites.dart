import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:namer_app/auth/structure/controllers/auth_controller.dart';
import 'package:namer_app/pokemon/structure/controllers/user_favorites_controller.dart';
import 'package:namer_app/pokemon/widgets/my_app_bar.dart';
import 'package:namer_app/pokemon/widgets/pokemon_card.dart';

class PokemonFavorites extends StatelessWidget {
  PokemonFavorites({ Key? key }) : super(key: key);

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context){
    // PokemonController pokemonController = Get.find();
    AuthController authController = Get.find();
    UserFavoritesController userFavoritesController = Get.find();

    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 1.1;
    final double itemWidth = size.width / 2;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              MyAppBar(
                authController: authController,
                leftIcon: Icons.home,
                leftFuntion: (){
                  Get.back();
                },
                textTap: (){
                  Get.snackbar(
                    "Favorites",
                    "You have ${userFavoritesController.favorites.length} favorites",
                    backgroundColor: Colors.grey[700],
                    colorText: Colors.white,
                  );
                },
              ),
              const SizedBox(height: 15),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Obx(() {
                        if (userFavoritesController.favorites.isEmpty) {
                          // Muestra un indicador de carga mientras se obtienen los datos.
                          return const CircularProgressIndicator();
                        } else {
                          return GridView.count(
                            shrinkWrap: true, // Esto permite que el GridView se ajuste a su contenido.
                            childAspectRatio: (itemWidth / itemHeight),
                            physics: const NeverScrollableScrollPhysics(), // Deshabilita el scroll del GridView.
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                            crossAxisCount: 2,
                            children: userFavoritesController.favorites.map((pokemon) {
                              return PokemonCard(
                                pokemon: pokemon,
                              );
                            }).toList(),
                          );
                        }
                      }),
                    ],
                  ),
                ),
              )
            ]
          ),
        ),
      ),
    );
  }
}