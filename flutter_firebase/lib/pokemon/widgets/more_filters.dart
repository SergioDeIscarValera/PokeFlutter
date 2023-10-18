import 'package:PokeFlutter/pokemon/models/type_pokemon.dart';
import 'package:PokeFlutter/pokemon/structure/controllers/search_filter_controller.dart';
import 'package:PokeFlutter/pokemon/utils/pokemon_stat_to_color.dart';
import 'package:PokeFlutter/pokemon/utils/pokemon_type_to_color.dart';
import 'package:PokeFlutter/utils/string_funtions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class MoreFilters extends StatelessWidget {
  const MoreFilters({Key? key, required this.searchFilterController})
      : super(key: key);

  final SearchFilterController searchFilterController;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: const Text(
              "More filters:",
              style: TextStyle(fontSize: 24, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text("Filter by type:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 40),
                    const TypeFilter(),
                    const SizedBox(width: 10),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                            Icons.filter_alt /*Icons.filter_alt_off*/))
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    StatsFilters(
                        searchFilterController: searchFilterController),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatsFilters extends StatelessWidget {
  const StatsFilters({
    super.key,
    required this.searchFilterController,
  });

  final SearchFilterController searchFilterController;
  final double spaceBetween = 15;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Filter by stats:",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: spaceBetween),
          StatFilter(
            statName: "HP",
            color: Color(PokemonStatsToColor.getColor("hp") ?? 0XFF000000),
            values: searchFilterController.statsRangeValues["hp"] ??
                const RangeValues(0, 255),
            searchFilterController: searchFilterController,
          ),
          SizedBox(height: spaceBetween),
          StatFilter(
            statName: "Attack",
            color: Color(PokemonStatsToColor.getColor("att") ?? 0XFF000000),
            values: searchFilterController.statsRangeValues["att"] ??
                const RangeValues(0, 255),
            searchFilterController: searchFilterController,
          ),
          SizedBox(height: spaceBetween),
          StatFilter(
            statName: "Defense",
            color: Color(PokemonStatsToColor.getColor("def") ?? 0XFF000000),
            values: searchFilterController.statsRangeValues["def"] ??
                const RangeValues(0, 255),
            searchFilterController: searchFilterController,
          ),
          SizedBox(height: spaceBetween),
          StatFilter(
            statName: "Sp. Atk",
            color: Color(PokemonStatsToColor.getColor("s-att") ?? 0XFF000000),
            values: searchFilterController.statsRangeValues["s-att"] ??
                const RangeValues(0, 255),
            searchFilterController: searchFilterController,
          ),
          SizedBox(height: spaceBetween),
          StatFilter(
            statName: "Sp. Def",
            color: Color(PokemonStatsToColor.getColor("s-def") ?? 0XFF000000),
            values: searchFilterController.statsRangeValues["s-def"] ??
                const RangeValues(0, 255),
            searchFilterController: searchFilterController,
          ),
          SizedBox(height: spaceBetween),
          StatFilter(
            statName: "Speed",
            color: Color(PokemonStatsToColor.getColor("spe") ?? 0XFF000000),
            values: searchFilterController.statsRangeValues["spe"] ??
                const RangeValues(0, 255),
            searchFilterController: searchFilterController,
          ),
        ],
      );
    });
  }
}

class StatFilter extends StatelessWidget {
  const StatFilter({
    Key? key,
    required this.statName,
    required this.color,
    required this.values,
    required this.searchFilterController,
  }) : super(key: key);

  final SearchFilterController searchFilterController;
  final String statName;
  final Color color;
  final RangeValues values;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          statName,
          style: TextStyle(color: color, fontSize: 16),
        ),
        const SizedBox(width: 10),
        RangeSlider(
          values: values,
          onChanged: (value) {
            searchFilterController.changeStatsRangeValues(statName, value);
          },
          max: 255,
        )
      ],
    );
  }
}

class TypeFilter extends StatelessWidget {
  const TypeFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      items: TypePokemon.values.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
                color: Color(PokemonTypeToColor.getColor(type.toString()) ??
                    0XFF000000)),
            margin: const EdgeInsets.all(0),
            child:
                Text(StringFunctions.capitalize(type.toString().split(".")[1]),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center),
          ),
        );
      }).toList(),
      onChanged: (value) {},
      icon: const Icon(Icons.keyboard_arrow_down),
      hint: const Text("Select type"),
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
      dropdownColor: Colors.grey[100],
      borderRadius: BorderRadius.circular(8),
      menuMaxHeight: 400,
    );
  }
}
