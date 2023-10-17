import 'package:PokeFlutter/auth/structure/controllers/auth_controller.dart';
import 'package:PokeFlutter/pokemon/models/pokemon_dto.dart';
import 'package:PokeFlutter/pokemon/structure/controllers/user_favorites_controller.dart';
import 'package:PokeFlutter/pokemon/utils/pokemon_type_to_color.dart';
import 'package:PokeFlutter/pokemon/widgets/pokemon_card_type.dart';
import 'package:PokeFlutter/routes/app_routes.dart';
import 'package:PokeFlutter/utils/string_funtions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PokemonCard extends StatelessWidget {
  PokemonCard({
    Key? key,
    required this.pokemon,
  }) : super(key: key) {
    _cardColor = Color(
        PokemonTypeToColor.getColor(pokemon.type.toString()) ?? 0xFFFFFFFF);
  }
  final AuthController _authController = Get.find();
  final UserFavoritesController _userFavoritesController = Get.find();
  final PokemonDto pokemon;
  late Color _cardColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.POKEMON_INFO, arguments: {"id": pokemon.id!});
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      StringFunctions.capitalize(pokemon.name ?? ""),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    PokemonCardType(type: pokemon.type),
                    PokemonCardType(type: pokemon.subType),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: 5, // Ajusta la posición de la imagen
            top: 5,
            child: Image.network(
              pokemon.image ?? "",
              height: 90,
              width: 90,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            left: 142,
            top: 3,
            child: Obx(() {
              var email = _authController.firebaseUser.value?.email;
              var isFavorite =
                  _userFavoritesController.isFavorite(poke: pokemon);

              Function onPressed;
              if (_authController.firebaseUser.value == null) {
                onPressed = () => Get.snackbar(
                    "Error", "You must be logged in to add favorites");
              } else {
                onPressed = () => _userFavoritesController.changeFavorite(
                      email: email ?? "",
                      poke: pokemon,
                    );
              }

              var icon = isFavorite ? Icons.favorite : Icons.favorite_border;
              var color = isFavorite ? Colors.red : Colors.white;
              return GestureDetector(
                onTap: () => onPressed.call(),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
