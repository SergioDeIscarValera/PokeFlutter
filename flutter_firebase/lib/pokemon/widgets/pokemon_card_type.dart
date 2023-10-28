import 'package:PokeFlutter/pokemon/models/pokemon_type.dart';
import 'package:PokeFlutter/utils/string_funtions.dart';
import 'package:flutter/material.dart';

class PokemonCardType extends StatelessWidget {
  final PokemonType? type;
  const PokemonCardType({Key? key, required this.type, this.fontSize = 12})
      : super(key: key);

  final double fontSize;
  @override
  Widget build(BuildContext context) {
    if (type == null) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: type?.color ?? Colors.white,
          border: Border.all(color: Colors.white, width: 2)),
      child: Text(
        StringFunctions.capitalize(type.toString().replaceRange(0, 12, "")),
        style: TextStyle(
          color: Colors.black,
          fontSize: fontSize,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}
