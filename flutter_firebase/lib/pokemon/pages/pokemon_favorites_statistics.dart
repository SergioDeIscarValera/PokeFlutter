import 'dart:math';

import 'package:PokeFlutter/auth/structure/controllers/auth_controller.dart';
import 'package:PokeFlutter/pokemon/models/pokemon_dto.dart';
import 'package:PokeFlutter/pokemon/models/pokemon_generations.dart';
import 'package:PokeFlutter/pokemon/models/pokemon_stats.dart';
import 'package:PokeFlutter/pokemon/models/pokemon_type.dart';
import 'package:PokeFlutter/pokemon/structure/controllers/pokemon_favorites_statistics_controller.dart';
import 'package:PokeFlutter/pokemon/structure/controllers/user_favorites_controller.dart';
import 'package:PokeFlutter/pokemon/utils/pokemon_generation_utils.dart';
import 'package:PokeFlutter/pokemon/utils/pokemon_stat_to_color.dart';
import 'package:PokeFlutter/pokemon/utils/pokemon_type_to_color.dart';
import 'package:PokeFlutter/pokemon/widgets/barchart_axieTitle.dart';
import 'package:PokeFlutter/pokemon/widgets/my_app_bar.dart';
import 'package:PokeFlutter/pokemon/widgets/pokemon_stats_chart.dart';
import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PokemonFavoritesStatistics extends StatelessWidget {
  static int count = 0; // NO INCREMENTA VALUE EN getAxiTitles
  const PokemonFavoritesStatistics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find();
    UserFavoritesController userFavoritesController = Get.find();
    PokemonFavoritesStatisticsController pokemonFSController = Get.find();
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyAppBar(
                authController: authController,
                leftIcon: Icons.home,
                leftFuntion: () {
                  Get.back();
                },
                textTap: () {},
              ),
              const SizedBox(height: 15),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      PieChartPokemon(
                        pokemonFSController: pokemonFSController,
                        userFavoritesController: userFavoritesController,
                      ),
                      BarCharPokemon(
                        userFavoritesController: userFavoritesController,
                      ),
                      _RadarChartPokemonContainer(
                        userFavoritesController: userFavoritesController,
                        pokemonFSController: pokemonFSController,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RadarChartPokemonContainer extends StatelessWidget {
  const _RadarChartPokemonContainer({
    super.key,
    required this.userFavoritesController,
    required this.pokemonFSController,
  });

  final UserFavoritesController userFavoritesController;
  final PokemonFavoritesStatisticsController pokemonFSController;

  @override
  Widget build(BuildContext context) {
    return _GenericContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Pokemons By Stats:",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Obx(
            () => Row(
              children: [
                DropdownButton(
                  items: userFavoritesController.favorites.value
                      .toSet()
                      .map(
                        (pokemon) => DropdownMenuItem(
                          value: pokemon,
                          child: Text(
                            pokemon.name!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    pokemonFSController.pokemonSelected.value = value;
                  },
                  icon: const Icon(Icons.keyboard_arrow_down),
                  value: pokemonFSController.pokemonSelected.value,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  hint: const Text("Select a pokemon"),
                  dropdownColor: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  menuMaxHeight: 400,
                ),
                IconButton(
                  onPressed: () {
                    pokemonFSController.pokemonSelected.value = null;
                  },
                  icon: Icon(pokemonFSController.pokemonSelected.value == null
                      ? Icons.filter_alt
                      : Icons.filter_alt_off),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          Obx(
            () => RadarChartPokemon(
              pokemons: userFavoritesController.favorites.value,
              pokemonSelected: pokemonFSController.pokemonSelected.value,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class RadarChartPokemon extends StatelessWidget {
  const RadarChartPokemon(
      {Key? key, required this.pokemons, required this.pokemonSelected})
      : super(key: key);
  final List<PokemonDto> pokemons;
  final PokemonDto? pokemonSelected;

  @override
  Widget build(BuildContext context) {
    if (pokemons.isEmpty) {
      return const Text("No pokemons");
    }

    if (pokemonSelected != null) {
      // Para que el seleccionado este el ultimo
      pokemons.removeWhere((element) => element.id == pokemonSelected?.id);
      pokemons.add(pokemonSelected!);
    }

    final List<RadarDataSet> radarDataSet = pokemons.map((e) {
      return RadarDataSet(
        fillColor: PokemonTypeToColor.getColor(e.type!, Colors.white)
            .withOpacity(e.id == pokemonSelected?.id ? 1 : 0.15),
        dataEntries: [
          RadarEntry(value: e.stats![PokemonStats.hp]!.toDouble()),
          RadarEntry(value: e.stats![PokemonStats.attack]!.toDouble()),
          RadarEntry(value: e.stats![PokemonStats.defense]!.toDouble()),
          RadarEntry(value: e.stats![PokemonStats.specialAttack]!.toDouble()),
          RadarEntry(value: e.stats![PokemonStats.specialDefense]!.toDouble()),
          RadarEntry(value: e.stats![PokemonStats.speed]!.toDouble()),
        ],
        borderColor:
            PokemonTypeToColor.getColor(e.type!, Colors.white).withOpacity(0.5),
        borderWidth: 2,
        entryRadius: 5,
      );
    }).toList();

    final wight = MediaQuery.of(context).size.width;
    return SizedBox(
      width: wight * 0.8,
      height: wight * 0.8,
      child: RadarChart(
        RadarChartData(
          dataSets: radarDataSet,
          getTitle: (index, angle) => RadarChartTitle(
              text: PokemonStatsNamed(PokemonStats.values[index]).name),
          titleTextStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            //color: PokemonStatsToColor.getColor(PokemonStats.values[index], Colors.black),
          ),
          tickBorderData: const BorderSide(color: Colors.transparent),
          radarTouchData: RadarTouchData(
            touchCallback: (FlTouchEvent event, touchResponse) {
              if (!event.isInterestedForInteractions ||
                  touchResponse == null ||
                  touchResponse.touchedSpot == null) {
                return;
              }
            },
          ),
          radarShape: RadarShape.polygon,
        ),
        swapAnimationDuration: const Duration(milliseconds: 250),
      ),
    );
  }
}

class BarCharPokemon extends StatelessWidget {
  const BarCharPokemon({
    super.key,
    required this.userFavoritesController,
  });

  final UserFavoritesController userFavoritesController;

  @override
  Widget build(BuildContext context) {
    var favoritesSorted = userFavoritesController.favorites.value
      ..sort((a, b) => a.generation!.index.compareTo(b.generation!.index));

    var entries = favoritesSorted
        .groupListsBy((element) => element.generation!)
        .entries
        .toList();

    final List<BarChartGroupData> chartData = userFavoritesController.favorites
        .groupListsBy((element) => element.generation!)
        .entries
        .map((e) {
      return BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(
            toY: e.value.length.toDouble(),
            width: 20,
            gradient: PokemonGenerationsUtils.getGradient(e.key, Colors.white),
            borderRadius: BorderRadius.circular(4),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: favoritesSorted.length.toDouble(),
              color: Colors.grey[300],
            ),
          ),
        ],
      );
    }).toList();

    var width = MediaQuery.of(context).size.width;

    return _GenericContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Pokemons By Generations:",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: width * 0.8,
            height: width * 0.6,
            child: BarChart(
              swapAnimationDuration: const Duration(milliseconds: 250),
              BarChartData(
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: chartData,
                groupsSpace: 5,
                minY: 0,
                maxY: favoritesSorted.length.toDouble(),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) => getAxiTitles(
                        value: value,
                        titles: entries
                            .map((e) => e.key.toString().split(".")[1])
                            .toList(),
                        meta: meta,
                        angle: 0,
                        offset: Offset.zero,
                        setIndex: (newIndex) =>
                            PokemonStatsChart.count = newIndex,
                        index: PokemonStatsChart.count,
                        limit: entries.length,
                        color: (value) => PokemonGenerationsUtils.getGradient(
                                PokemonGenerations.values[value], Colors.black)
                            .colors[0],
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) => getAxiTitles(
                        value: value,
                        titles: entries
                            .map((e) => e.value.length.toString())
                            .toList(),
                        meta: meta,
                        angle: 0,
                        offset: Offset.zero,
                        setIndex: (newIndex) =>
                            PokemonStatsChart.count = newIndex,
                        index: PokemonStatsChart.count,
                        limit: entries.length,
                        color: (value) => PokemonGenerationsUtils.getGradient(
                                PokemonGenerations.values[value], Colors.black)
                            .colors[0],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PieChartPokemon extends StatelessWidget {
  PieChartPokemon(
      {Key? key,
      required this.userFavoritesController,
      required this.pokemonFSController})
      : super(key: key);

  UserFavoritesController userFavoritesController;
  PokemonFavoritesStatisticsController pokemonFSController;
  @override
  Widget build(BuildContext context) {
    return _GenericContainer(
      child: Column(
        children: [
          const Text(
            "Types Of Pokemon:",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          Obx(
            () => SizedBox(
              width: 250,
              height: 250,
              child: PieChart(
                swapAnimationDuration: const Duration(milliseconds: 250),
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        pokemonFSController.touchIndex = -1;
                        return;
                      }
                      pokemonFSController.touchIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    },
                  ),
                  sections: _getPiesChartSectionData(
                    userFavoritesController.favorites,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  List<PieChartSectionData> _getPiesChartSectionData(
      List<PokemonDto> pokemons) {
    //var mapedPokemons = pokemons.groupListsBy((element) => element.type!);
    final Map<PokemonType, List<PokemonDto>> mapedPokemons = {};
    var pokemonsCount = 0;

    for (var element in pokemons) {
      // Añadir al tipo y si tiene subtipo añadirlo tambien
      if (mapedPokemons.containsKey(element.type)) {
        mapedPokemons[element.type]!.add(element);
      } else {
        mapedPokemons[element.type!] = [element];
      }
      pokemonsCount++;
      if (element.subType != null) {
        if (mapedPokemons.containsKey(element.subType)) {
          mapedPokemons[element.subType]!.add(element);
        } else {
          mapedPokemons[element.subType!] = [element];
        }
        pokemonsCount++;
      }
    }
    return mapedPokemons.entries.map((e) {
      final index = mapedPokemons.keys.toList().indexOf(e.key);
      final isTouched = index == pokemonFSController.touchIndex;
      final fontSize = isTouched ? 24.0 : 14.0;
      final radius = isTouched ? 80.0 : 70.0;
      return PieChartSectionData(
        value: e.value.length.toDouble(),
        color: PokemonTypeToColor.getColor(e.key, Colors.white),
        //title: "${(e.value.length * 100 / pokemonsCount).toStringAsFixed(1)}%",
        title: PokemonTypeNamed(e.key).name,
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgePositionPercentageOffset: 1.3,
        badgeWidget: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: PokemonTypeToColor.getColor(e.key, Colors.black),
              width: 2,
            ),
          ),
          child: Text(
            //PokemonTypeNamed(e.key!).name,
            "${(e.value.length * 100 / pokemonsCount).toStringAsFixed(1)}%",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: PokemonTypeToColor.getColor(e.key, Colors.black),
            ),
          ),
        ),
      );
    }).toList();
  }
}

class _GenericContainer extends StatelessWidget {
  _GenericContainer({Key? key, required this.child}) : super(key: key);
  Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [child],
      ),
    );
  }
}
