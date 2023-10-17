import 'package:PokeFlutter/pokemon/models/pokemon_dto.dart';
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
  });

  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final int crossAxisCount;
  final RxList<PokemonDto> pokemonList;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (pokemonList.isEmpty) {
        // Muestra un indicador de carga mientras se obtienen los datos.
        return const CircularProgressIndicator();
      } else {
        return GridView.count(
          shrinkWrap:
              true, // Esto permite que el GridView se ajuste a su contenido.
          childAspectRatio: (1.85 / 1), // width / height
          physics:
              const NeverScrollableScrollPhysics(), // Deshabilita el scroll del GridView.
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
          crossAxisCount: crossAxisCount,
          children: pokemonList.map((pokemon) {
            return PokemonCard(
              pokemon: pokemon,
            );
          }).toList(),
        );
      }
    });
  }
}
