import 'package:PokeFlutter/pokemon/structure/controllers/pokemon_controller.dart';
import 'package:PokeFlutter/pokemon/structure/controllers/search_filter_controller.dart';
import 'package:PokeFlutter/pokemon/widgets/more_filters.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MySearch extends StatelessWidget {
  const MySearch({super.key});

  @override
  Widget build(BuildContext context) {
    SearchFilterController searchFilterController = Get.find();
    PokemonController pokemonController = Get.find();
    return SearchAnchor(
      builder: (context, controller) {
        return SearchBar(
          controller: searchFilterController.searchController,
          onChanged: (value) {
            searchFilterController.applyFilters(value, pokemonController);
          },
          onSubmitted: (value) {
            searchFilterController.applyFilters(value, pokemonController);
          },
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
                  searchFilterController.clearFilters(pokemonController);
                  searchFilterController.applyFilters("", pokemonController);
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ),
            Obx(() {
              return Tooltip(
                message: 'More filters',
                child: IconButton(
                  onPressed: () {
                    searchFilterController.changeMoreFilterIsOpen();
                    // Open bottom sheet
                    if (searchFilterController.moreFilterIsOpen) {
                      showModalBottomSheet(
                        context: context,
                        useSafeArea: true,
                        enableDrag: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return MoreFilters(
                            searchFilterController: searchFilterController,
                          );
                        },
                      ).whenComplete(() =>
                          searchFilterController.changeMoreFilterIsOpen());
                    }
                  },
                  icon: Icon(
                    searchFilterController.moreFilterIsOpen
                        ? Icons.close
                        : Icons.tune,
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
