import 'package:PokeFlutter/pokemon/models/pokemon_dto.dart';
import 'package:PokeFlutter/pokemon/structure/controllers/user_favorites_controller.dart';
import 'package:PokeFlutter/pokemon/widgets/pokemon_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GridOfPokemons extends StatelessWidget {
  const GridOfPokemons({
    super.key,
    required this.pokemonList,
    required this.mainAxisSpacing,
    required this.crossAxisSpacing,
    required this.crossAxisCount,
    this.progressIndicator = true,
    this.otherWidgets = const [],
    this.padding = const EdgeInsets.all(0),
    this.icon = Icons.favorite_border,
    this.iconSecondary = Icons.favorite,
    this.onCardTap,
    this.checkPokemon,
    this.iconColor = Colors.white,
    this.iconSecondaryColor = Colors.red,
  });

  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final int crossAxisCount;
  final RxList<PokemonDto> pokemonList;
  final bool progressIndicator;
  final List<Widget> otherWidgets;
  final EdgeInsetsGeometry padding;
  final IconData icon;
  final IconData iconSecondary;
  final Function({required PokemonDto pokemon})? onCardTap;
  final bool Function(PokemonDto)? checkPokemon;
  final Color iconColor;
  final Color iconSecondaryColor;

  @override
  Widget build(BuildContext context) {
    UserFavoritesController userFavoritesController = Get.find();
    return Obx(() {
      if (pokemonList.isEmpty && progressIndicator) {
        // Muestra un indicador de carga mientras se obtienen los datos.
        return const CircularProgressIndicator();
      } else {
        return GridView.count(
          padding: padding,
          shrinkWrap:
              true, // Esto permite que el GridView se ajuste a su contenido.
          childAspectRatio: (1.85 / 1), // width / height
          physics:
              const NeverScrollableScrollPhysics(), // Deshabilita el scroll del GridView.
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
          crossAxisCount: crossAxisCount,
          children: [
            ...pokemonList.map((pokemon) {
              return PokemonCard(
                pokemon: pokemon,
                icon: icon,
                iconSecondary: iconSecondary,
                onButtonPressed: (
                  _authController,
                  _userFavoritesController,
                  email,
                ) {
                  if (onCardTap != null) {
                    onCardTap!(pokemon: pokemon);
                    return;
                  }
                  if (_authController.firebaseUser == null ||
                      _authController.firebaseUser?.isAnonymous == true) {
                    Get.snackbar(
                        "Error", "You must be logged in to add favorites");
                  } else {
                    _userFavoritesController.changeFavorite(
                      email: email,
                      poke: pokemon,
                    );
                  }
                },
                checkPokemon: (poke) {
                  if (checkPokemon != null) {
                    return checkPokemon!(poke);
                  }
                  return userFavoritesController.isFavorite(poke: pokemon);
                },
                iconColor: iconColor,
                iconSecondaryColor: iconSecondaryColor,
              );
            }).toList(),
            ...otherWidgets,
          ],
        );
      }
    });
  }
}
