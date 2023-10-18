import 'package:PokeFlutter/pokemon/models/pokemon_filter_class.dart';
import 'package:PokeFlutter/pokemon/structure/controllers/pokemon_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchFilterController extends GetxController {
  final RxBool _isFiltering = false.obs;
  bool get isFiltering => _isFiltering.value;
  set isFiltering(bool newValue) => _isFiltering.value = newValue;

  final RxBool _moreFilterIsOpen = false.obs;
  bool get moreFilterIsOpen => _moreFilterIsOpen.value;
  set moreFilterIsOpen(bool newValue) => _moreFilterIsOpen.value = newValue;

  RxMap<String, RangeValues> statsRangeValues = <String, RangeValues>{}.obs;

  TextEditingController searchController = TextEditingController();

  @override
  void onReady() {
    _resetStatsRangeValues();
    super.onReady();
  }

  void changeMoreFilterIsOpen() {
    moreFilterIsOpen = !moreFilterIsOpen;
  }

  void applyFilters(String textFild, PokemonController pokemonController) {
    _isFiltering.value = textFild.isNotEmpty;
    PokemonFilter filter = PokemonFilter(textFild: textFild);
    pokemonController.filterAllPokemons(filter: filter);
  }

  void clearFilters(PokemonController pokemonController) {
    _isFiltering.value = false;
    searchController.clear();
    _resetStatsRangeValues();
    applyFilters("", pokemonController);
  }

  void changeStatsRangeValues(String stat, RangeValues rangeValues) {
    statsRangeValues.value[stat] = rangeValues;
  }

  void _resetStatsRangeValues() {
    statsRangeValues.value = {
      "hp": const RangeValues(0, 255),
      "att": const RangeValues(0, 255),
      "def": const RangeValues(0, 255),
      "s-att": const RangeValues(0, 255),
      "s-def": const RangeValues(0, 255),
      "spe": const RangeValues(0, 255),
    };
  }
}
