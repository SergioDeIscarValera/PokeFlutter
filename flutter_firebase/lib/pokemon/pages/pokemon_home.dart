import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:namer_app/auth/structure/controllers/auth_controller.dart';
import 'package:namer_app/pokemon/structure/controllers/pokemon_controller.dart';
import 'package:namer_app/pokemon/structure/controllers/user_favorites_controller.dart';
import 'package:namer_app/pokemon/widgets/my_app_bar.dart';
import 'package:namer_app/pokemon/widgets/pokemon_card.dart';
import 'package:namer_app/routes/app_routes.dart';

class PokemonHome extends StatelessWidget {
  PokemonHome({ Key? key }) : super(key: key);

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context){
    PokemonController pokemonController = Get.find();
    AuthController authController = Get.find();
    UserFavoritesController userFavoritesController = Get.find();
    var userEmail = authController.firebaseUser.value?.email ?? "Anonymous";
    if (pokemonController.pokemonList.isEmpty) {
      pokemonController.getPokemonList(offset: 0, limit: 6);
    }
    userFavoritesController.refreshFavorites(
      email: userEmail,
      pokemonController: pokemonController
    );

    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 1.1;
    final double itemWidth = size.width / 2;

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
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 45),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextField(
                                controller: pokemonController.searchController,
                                decoration: const InputDecoration(
                                  hintText: "Search",
                                  hintStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                  border: InputBorder.none,
                                ),
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              )
                            ),
                            IconButton(
                              onPressed: (){
                                pokemonController.searchPokemonByName(
                                  name: pokemonController.searchController.text,
                                  onFail: (){
                                    Get.snackbar(
                                      "Error",
                                      "Pokemon not found",
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                  }
                                );
                                _scrollController.jumpTo(_scrollController.position.minScrollExtent);
                              },
                              icon: const Icon(Icons.search),
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  MyAppBar(
                    authController: authController,
                    leftIcon: Icons.person,
                    leftFuntion: (){
                      Get.toNamed(Routes.POKEMON_FAVORITES);
                    },
                    textTap: (){
                      pokemonController.resetPokemonList();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Obx(() {
                        if (pokemonController.pokemonList.isEmpty) {
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
                            children: pokemonController.pokemonList.map((pokemon) {
                              return PokemonCard(
                                pokemon: pokemon,
                              );
                            }).toList(),
                          );
                        }
                      }),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: (){
                              pokemonController.getPreviousPokemonList();
                              _scrollController.jumpTo(_scrollController.position.minScrollExtent);
                            },
                            icon: const Icon(Icons.arrow_back_ios),
                          ),
                          IconButton(
                            onPressed: (){
                              pokemonController.getNextPokemonList();
                              _scrollController.jumpTo(_scrollController.position.minScrollExtent);
                            },
                            icon: const Icon(Icons.arrow_forward_ios),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}