import 'package:PokeFlutter/pokemon/models/pokemon_generations.dart';
import 'package:PokeFlutter/pokemon/models/pokemon_stats.dart';
import 'package:PokeFlutter/pokemon/models/pokemon_type.dart';
import 'package:PokeFlutter/pokemon/structure/controllers/search_filter_controller.dart';
import 'package:PokeFlutter/pokemon/utils/pokemon_stat_to_color.dart';
import 'package:PokeFlutter/pokemon/utils/pokemon_type_to_color.dart';
import 'package:PokeFlutter/utils/string_funtions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Filter by type:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TypeFilter(
                              hint: "Select type...",
                              typeFilter: searchFilterController.typeFilter,
                            ),
                            TypeFilter(
                              hint: "Select second type...",
                              typeFilter: searchFilterController.subTypeFilter,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Filter by generation:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        GenerationFilter(
                          hint: "Select generation...",
                          genFilter: searchFilterController.generationFilter,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    StatsFilters(
                      searchFilterController: searchFilterController,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GenerationFilter extends StatelessWidget {
  const GenerationFilter(
      {Key? key, required this.genFilter, required this.hint})
      : super(key: key);
  final String hint;
  final Rx<PokemonGenerations?> genFilter;
  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DropdownButton(
              items: PokemonGenerations.values.map((gen) {
                return DropdownMenuItem(
                  value: gen,
                  child: Text(
                      StringFunctions.capitalize(
                          PokemonGenerationsNamed(gen).name),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center),
                );
              }).toList(),
              value: genFilter.value,
              onChanged: (value) {
                genFilter.value = value;
              },
              icon: const Icon(Icons.keyboard_arrow_down),
              hint: Text(hint),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              dropdownColor: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              menuMaxHeight: 400,
            ),
            const SizedBox(width: 10),
            Tooltip(
              message: "Clear generation filter",
              child: IconButton(
                  onPressed: () {
                    genFilter.value = null;
                  },
                  icon: Icon(genFilter.value == null
                      ? Icons.filter_alt
                      : Icons.filter_alt_off)),
            )
          ],
        ));
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
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Filter by stats:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 20),
              Tooltip(
                message: "Reset stats values",
                child: IconButton(
                    onPressed: () {
                      searchFilterController.resetStatsRangeValues();
                    },
                    icon: const Icon(Icons.sync)),
              ),
            ],
          ),
          SizedBox(height: spaceBetween),
          StatFilter(
            statKey: PokemonStats.hp,
            color: PokemonStatsToColor.getColor(PokemonStats.hp, Colors.black),
            values: searchFilterController.statsRangeValues[PokemonStats.hp]!,
            searchFilterController: searchFilterController,
          ),
          SizedBox(height: spaceBetween),
          StatFilter(
            statKey: PokemonStats.attack,
            color:
                PokemonStatsToColor.getColor(PokemonStats.attack, Colors.black),
            values:
                searchFilterController.statsRangeValues[PokemonStats.attack]!,
            searchFilterController: searchFilterController,
          ),
          SizedBox(height: spaceBetween),
          StatFilter(
            statKey: PokemonStats.defense,
            color: PokemonStatsToColor.getColor(
                PokemonStats.defense, Colors.black),
            values:
                searchFilterController.statsRangeValues[PokemonStats.defense]!,
            searchFilterController: searchFilterController,
          ),
          SizedBox(height: spaceBetween),
          StatFilter(
            statKey: PokemonStats.specialAttack,
            color: PokemonStatsToColor.getColor(
                PokemonStats.specialAttack, Colors.black),
            values: searchFilterController
                .statsRangeValues[PokemonStats.specialAttack]!,
            searchFilterController: searchFilterController,
          ),
          SizedBox(height: spaceBetween),
          StatFilter(
            statKey: PokemonStats.specialDefense,
            color: PokemonStatsToColor.getColor(
                PokemonStats.specialDefense, Colors.black),
            values: searchFilterController
                .statsRangeValues[PokemonStats.specialDefense]!,
            searchFilterController: searchFilterController,
          ),
          SizedBox(height: spaceBetween),
          StatFilter(
            statKey: PokemonStats.speed,
            color:
                PokemonStatsToColor.getColor(PokemonStats.speed, Colors.black),
            values:
                searchFilterController.statsRangeValues[PokemonStats.speed]!,
            searchFilterController: searchFilterController,
          ),
        ],
      ),
    );
  }
}

class StatFilter extends StatelessWidget {
  const StatFilter({
    Key? key,
    required this.statKey,
    required this.color,
    required this.values,
    required this.searchFilterController,
  }) : super(key: key);

  final SearchFilterController searchFilterController;
  final PokemonStats statKey;
  final Color color;
  final RangeValues values;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            "${PokemonStatsNamed(statKey).name}:",
            style: TextStyle(color: color, fontSize: 16),
          ),
        ),
        SizedBox(
          width: 30,
          child: Text(values.start.round().toString(),
              style: TextStyle(color: color, fontSize: 16)),
        ),
        Expanded(
          flex: 3,
          child: RangeSlider(
            values: values,
            onChanged: (newValue) {
              searchFilterController.statsRangeValues[statKey] = newValue;
            },
            min: 0.0,
            max: 255.0,
            activeColor: color,
          ),
        ),
        SizedBox(
          width: 30,
          child: Text(values.end.round().toString(),
              style: TextStyle(color: color, fontSize: 16)),
        ),
      ],
    );
  }
}

class TypeFilter extends StatelessWidget {
  const TypeFilter({Key? key, required this.typeFilter, required this.hint})
      : super(key: key);

  final String hint;
  final Rx<PokemonType?> typeFilter;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton(
            items: PokemonType.values.map((type) {
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
                      color: PokemonTypeToColor.getColor(type, Colors.black)),
                  margin: const EdgeInsets.all(0),
                  child: Text(
                      StringFunctions.capitalize(PokemonTypeNamed(type).name),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center),
                ),
              );
            }).toList(),
            value: typeFilter.value,
            onChanged: (value) {
              typeFilter.value = value;
            },
            icon: const Icon(Icons.keyboard_arrow_down),
            hint: Text(hint),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            dropdownColor: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            menuMaxHeight: 400,
          ),
          const SizedBox(width: 10),
          Tooltip(
            message: "Clear type filter",
            child: IconButton(
                onPressed: () {
                  typeFilter.value = null;
                },
                icon: Icon(typeFilter.value == null
                    ? Icons.filter_alt
                    : Icons.filter_alt_off)),
          )
        ],
      ),
    );
  }
}
