import 'package:PokeFlutter/pokemon/models/pokemon_dto.dart';
import 'package:PokeFlutter/pokemon/models/pokemon_generations.dart';
import 'package:PokeFlutter/pokemon/models/pokemon_stats.dart';
import 'package:PokeFlutter/pokemon/models/pokemon_type.dart';
import 'package:PokeFlutter/pokemon/widgets/more_filters.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MySearch extends StatelessWidget {
  const MySearch({
    super.key,
    required this.pokemons,
    required this.searchController,
    required this.statsRangeValues,
    required this.typeFilter,
    required this.subTypeFilter,
    required this.generationFilter,
    required this.moreFilterIsOpen,
    required this.changeMoreFilterIsOpen,
    required this.resetStatsRangeValues,
  });

  final RxList<PokemonDto> pokemons;
  final TextEditingController searchController;
  final RxMap<PokemonStats, RangeValues> statsRangeValues;
  final Rx<PokemonType?> typeFilter;
  final Rx<PokemonType?> subTypeFilter;
  final Rx<PokemonGenerations?> generationFilter;
  final RxBool moreFilterIsOpen;
  final Function changeMoreFilterIsOpen;
  final Function resetStatsRangeValues;

  @override
  Widget build(BuildContext context) {
    //SearchFilterController searchFilterController = Get.find();
    return SearchAnchor(
      builder: (context, controller) {
        return SearchBar(
          controller: searchController,
          onChanged: (value) {},
          onSubmitted: (value) {},
          textStyle: MaterialStateProperty.resolveWith(
            (_) => const TextStyle(
              color: Colors.white,
            ),
          ),
          hintStyle: MaterialStateProperty.resolveWith(
            (_) => const TextStyle(
              color: Colors.white,
            ),
          ),
          hintText: "Search Pokemon",
          leading: const Icon(
            Icons.search,
            color: Colors.white,
          ),
          trailing: <Widget>[
            Tooltip(
              message: "Clear search",
              child: IconButton(
                onPressed: () {
                  searchController.clear();
                },
                icon: const Icon(Icons.cancel, color: Colors.white),
              ),
            ),
            Obx(() {
              return Tooltip(
                message: 'More filters',
                child: IconButton(
                  onPressed: () {
                    changeMoreFilterIsOpen;
                    // Open bottom sheet
                    if (!moreFilterIsOpen.value) {
                      showModalBottomSheet(
                        context: context,
                        useSafeArea: true,
                        enableDrag: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return MoreFilters(
                            statsRangeValues: statsRangeValues,
                            typeFilter: typeFilter,
                            subTypeFilter: subTypeFilter,
                            generationFilter: generationFilter,
                            resetStatsRangeValues: resetStatsRangeValues,
                          );
                        },
                      ).whenComplete(() => changeMoreFilterIsOpen);
                    }
                  },
                  icon: Icon(
                    moreFilterIsOpen.value ? Icons.close : Icons.tune,
                    color: Colors.white,
                  ),
                ),
              );
            }),
          ],
          backgroundColor: MaterialStateColor.resolveWith(
            (_) => Colors.transparent,
          ),
        );
      },
      suggestionsBuilder: (context, controller) {
        return List.empty();
      },
    );
  }
}
