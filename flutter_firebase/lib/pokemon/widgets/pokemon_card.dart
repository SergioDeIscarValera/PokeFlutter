import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:namer_app/auth/structure/controllers/auth_controller.dart';
import 'package:namer_app/pokemon/models/pokemon.dart';
import 'package:namer_app/pokemon/structure/controllers/user_favorites_controller.dart';
import 'package:namer_app/pokemon/utils/pokemon_stat_to_color.dart';
import 'package:namer_app/pokemon/utils/pokemon_type_to_color.dart';
import 'package:namer_app/pokemon/widgets/pokemon_card_stat.dart';
import 'package:namer_app/utils/string_funtions.dart';

class PokemonCard extends StatelessWidget {
  PokemonCard({ 
    Key? key,
    required this.pokemon,
  }) : super(key: key){
    _cardColor = Color(PokemonTypeToColor.getColor(pokemon.type.toString()) ?? 0xFFFFFFFF);
  }

  final AuthController _authController = Get.find();
  final UserFavoritesController _userFavoritesController = Get.find();
  final Pokemon pokemon;
  late Color _cardColor;

  @override
  Widget build(BuildContext context){
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //PokemonName and favorite
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  StringFunctions.capitalize(pokemon.name ?? "") ,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Obx( (){
                  var email = _authController.firebaseUser.value?.email;
                  var isFavorite = _userFavoritesController.isFavorite(poke: pokemon);

                  Function onPressed;
                  if(_authController.firebaseUser.value == null){
                    onPressed = () => Get.snackbar("Error", "You must be logged in to add favorites");
                  }
                  else{
                    onPressed = () => _userFavoritesController.changeFavorite(
                      email: email ?? "",
                      poke: pokemon,
                    );
                  }

                  var icon = isFavorite ? Icons.favorite : Icons.favorite_border;
                  var color = isFavorite ? Colors.red : Colors.white;
                  return IconButton(
                    onPressed: (){
                      onPressed.call();
                    },
                    icon: Icon(icon),
                    color: color,
                  );
                }),
              ],
            ),
            //PokemonImage
            Image.network(
              pokemon.image ?? "",
              height: 100,
              width: 100,
              loadingBuilder: ((context, child, loadingProgress) => 
                loadingProgress == null ? child : const CircularProgressIndicator()
              ),
              semanticLabel: pokemon.name ?? "",
            ),
            //PokemonStats, crear un PokemonCardStat por cada stat que tenga el pokemon, en una columna
            Column(
              children: [
                PokemonCardStat(nameStat: "hp", valueStat: pokemon.stats?["hp"] ?? 0),
                PokemonCardStat(nameStat: "attack", valueStat: pokemon.stats?["attack"] ?? 0),
                PokemonCardStat(nameStat: "defense", valueStat: pokemon.stats?["defense"] ?? 0),
                PokemonCardStat(nameStat: "special-attack", valueStat: pokemon.stats?["special-attack"] ?? 0),
                PokemonCardStat(nameStat: "special-defense", valueStat: pokemon.stats?["special-defense"] ?? 0),
                PokemonCardStat(nameStat: "speed", valueStat: pokemon.stats?["speed"] ?? 0),
              ],
            ),

          ],
        ),
      ),
    );
  }
}