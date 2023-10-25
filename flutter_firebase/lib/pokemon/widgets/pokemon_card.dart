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
    required this.onButtonPressed,
    required this.icon,
    required this.iconSecondary,
    required this.checkPokemon,
    required this.iconColor,
    required this.iconSecondaryColor,
  }) : super(key: key) {
    _cardColor = PokemonTypeToColor.getColor(pokemon.type, Colors.white);
  }
  final AuthController _authController = Get.find();
  final UserFavoritesController _userFavoritesController = Get.find();
  final PokemonDto pokemon;
  late Color _cardColor;
  final Function(AuthController, UserFavoritesController, String)
      onButtonPressed;
  final IconData icon;
  final IconData iconSecondary;
  final bool Function(PokemonDto) checkPokemon;
  final Color iconColor;
  final Color iconSecondaryColor;

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
                        decoration: TextDecoration.none,
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
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const SizedBox(
                  width: 90,
                  height: 90,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  width: 90,
                  height: 90,
                  child: Center(
                    child: Icon(
                      Icons.error,
                      weight: 45,
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            right: 3,
            top: 3,
            child: Obx(() {
              var email = _authController.firebaseUser?.email;
              /*var isFavorite =
                  _userFavoritesController.isFavorite(poke: pokemon);
              var iconSelected = isFavorite ? iconSecondary : icon;
              var color = isFavorite ? Colors.red : Colors.white;*/
              var check = checkPokemon.call(pokemon);
              var iconSelected = check ? iconSecondary : icon;
              var color = check ? iconSecondaryColor : iconColor;
              return GestureDetector(
                onTap: () => onButtonPressed.call(
                    _authController, _userFavoritesController, email ?? ""),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: Icon(
                    iconSelected,
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
