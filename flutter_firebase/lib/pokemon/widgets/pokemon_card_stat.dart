import 'package:flutter/material.dart';
import 'package:namer_app/pokemon/utils/pokemon_stat_to_color.dart';

class PokemonCardStat extends StatelessWidget {
  late String nameStat;
  late int valueStat;
  late Color _color;
  
  PokemonCardStat({ 
    Key? key, 
    required this.nameStat, 
    required this.valueStat 
  }) : super(key: key){
    _color = Color(PokemonStatsToColor.getColor(nameStat) ?? 0xFFFFFFFF);
  }

  @override
  Widget build(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("${nameStat ?? ""}: ${valueStat.toString()}", style: const TextStyle(color: Colors.white, fontSize: 12)),
        Slider(
          value: valueStat.toDouble(),
          min: 0,
          max: 255,
          activeColor: _color,
          inactiveColor: Colors.grey[300],
          onChanged: (value) {},
        ),
      ]
    );
  }
}