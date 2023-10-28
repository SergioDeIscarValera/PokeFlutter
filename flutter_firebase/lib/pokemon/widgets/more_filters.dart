import 'package:PokeFlutter/pokemon/models/pokemon_generations.dart';
import 'package:PokeFlutter/pokemon/models/pokemon_stats.dart';
import 'package:PokeFlutter/pokemon/models/pokemon_type.dart';
import 'package:PokeFlutter/utils/string_funtions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MoreFilters extends StatelessWidget {
  const MoreFilters(
      {Key? key,
      required this.typeFilter,
      required this.subTypeFilter,
      required this.generationFilter,
      required this.resetStatsRangeValues,
      required this.statsRangeValues})
      : super(key: key);

  final Rx<PokemonType?> typeFilter;
  final Rx<PokemonType?> subTypeFilter;
  final Rx<PokemonGenerations?> generationFilter;
  final Function resetStatsRangeValues;
  final RxMap<PokemonStats, RangeValues> statsRangeValues;

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
                              typeFilter: typeFilter,
                            ),
                            TypeFilter(
                              hint: "Select second type...",
                              typeFilter: subTypeFilter,
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
                          genFilter: generationFilter,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    StatsFilters(
                      statsRangeValues: statsRangeValues,
                      resetStatsRangeValues: resetStatsRangeValues,
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
                          PokemonGenerationsUtils(gen).name),
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
    required this.statsRangeValues,
    required this.resetStatsRangeValues,
  });

  final double spaceBetween = 15;
  final Function resetStatsRangeValues;
  final RxMap<PokemonStats, RangeValues> statsRangeValues;

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
                    onPressed: () => resetStatsRangeValues.call(),
                    icon: const Icon(Icons.sync)),
              ),
            ],
          ),
          SizedBox(height: spaceBetween),
          StatFilter(
            statKey: PokemonStats.hp,
            color: PokemonStats.hp.color,
            values: statsRangeValues[PokemonStats.hp]!,
            statsRangeValues: statsRangeValues,
          ),
          SizedBox(height: spaceBetween),
          StatFilter(
            statKey: PokemonStats.attack,
            color: PokemonStats.attack.color,
            values: statsRangeValues[PokemonStats.attack]!,
            statsRangeValues: statsRangeValues,
          ),
          SizedBox(height: spaceBetween),
          StatFilter(
            statKey: PokemonStats.defense,
            color: PokemonStats.defense.color,
            values: statsRangeValues[PokemonStats.defense]!,
            statsRangeValues: statsRangeValues,
          ),
          SizedBox(height: spaceBetween),
          StatFilter(
            statKey: PokemonStats.specialAttack,
            color: PokemonStats.specialAttack.color,
            values: statsRangeValues[PokemonStats.specialAttack]!,
            statsRangeValues: statsRangeValues,
          ),
          SizedBox(height: spaceBetween),
          StatFilter(
            statKey: PokemonStats.specialDefense,
            color: PokemonStats.specialDefense.color,
            values: statsRangeValues[PokemonStats.specialDefense]!,
            statsRangeValues: statsRangeValues,
          ),
          SizedBox(height: spaceBetween),
          StatFilter(
            statKey: PokemonStats.speed,
            color: PokemonStats.speed.color,
            values: statsRangeValues[PokemonStats.speed]!,
            statsRangeValues: statsRangeValues,
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
    required this.statsRangeValues,
  }) : super(key: key);

  final RxMap<PokemonStats, RangeValues> statsRangeValues;
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
            "${PokemonStatsUtils(statKey).name}:",
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
              statsRangeValues[statKey] = newValue;
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
                    color: type.color,
                  ),
                  margin: const EdgeInsets.all(0),
                  child: Text(
                      StringFunctions.capitalize(PokemonTypeUtils(type).name),
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
