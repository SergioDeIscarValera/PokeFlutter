import 'package:PokeFlutter/pokemon/models/pokemon_filter_class.dart';
import 'package:PokeFlutter/pokemon/models/pokemon_generations.dart';
import 'package:PokeFlutter/pokemon/models/pokemon_stats.dart';
import 'package:PokeFlutter/pokemon/models/pokemon_type.dart';
import 'package:PokeFlutter/pokemon/structure/controllers/pokemon_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchFilterController extends GetxController {
  final RxBool _isFiltering = false.obs;
  bool get isFiltering => _isFiltering.value;
  set isFiltering(bool newValue) => _isFiltering.value = newValue;

  final RxBool moreFilterIsOpen = false.obs;

  RxMap<PokemonStats, RangeValues> statsRangeValues =
      <PokemonStats, RangeValues>{}.obs;

  TextEditingController searchController = TextEditingController();

  final Rx<PokemonType?> typeFilter = Rx<PokemonType?>(null);
  final Rx<PokemonType?> subTypeFilter = Rx<PokemonType?>(null);

  final Rx<PokemonGenerations?> generationFilter =
      Rx<PokemonGenerations?>(null);

  PokemonController pokemonController = Get.find();

  @override
  void onReady() {
    resetStatsRangeValues();
    searchController.addListener(() {
      applyFilters();
    });
    typeFilter.listen((_) {
      applyFilters();
    });
    subTypeFilter.listen((_) {
      applyFilters();
    });
    statsRangeValues.listen((_) {
      applyFilters();
    });
    generationFilter.listen((_) {
      applyFilters();
    });
    super.onReady();
  }

  void changeMoreFilterIsOpen() {
    moreFilterIsOpen.value = !moreFilterIsOpen.value;
  }

  void resetStatsRangeValues() {
    statsRangeValues.value = {
      PokemonStats.hp: const RangeValues(0, 255),
      PokemonStats.attack: const RangeValues(0, 255),
      PokemonStats.defense: const RangeValues(0, 255),
      PokemonStats.specialAttack: const RangeValues(0, 255),
      PokemonStats.specialDefense: const RangeValues(0, 255),
      PokemonStats.speed: const RangeValues(0, 255),
    };
  }

  void applyFilters() {
    pokemonController.filterAllPokemons(
        filter: PokemonFilter(
      textFild: searchController.value.text,
      type: typeFilter.value,
      subType: subTypeFilter.value,
      stats: statsRangeValues.value,
      generation: generationFilter.value,
    ));
    _isFiltering.value = searchController.value.text.isNotEmpty ||
        typeFilter.value != null ||
        subTypeFilter.value != null ||
        statsRangeValues.values
            .any((element) => element.start != 0 || element.end != 255) ||
        generationFilter.value != null;
  }
}
