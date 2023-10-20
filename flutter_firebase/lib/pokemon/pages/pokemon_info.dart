import 'package:PokeFlutter/pokemon/structure/controllers/pokemon_info_controller.dart';
import 'package:PokeFlutter/pokemon/utils/pokemon_type_to_color.dart';
import 'package:PokeFlutter/pokemon/widgets/pokemon_card_type.dart';
import 'package:PokeFlutter/pokemon/widgets/pokemon_stats_chart.dart';
import 'package:PokeFlutter/utils/string_funtions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class PokemonInfo extends StatelessWidget {
  const PokemonInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PokemonInfoController pokemonInfoController = Get.find();

    var id = Get.arguments["id"];
    pokemonInfoController.getFullPokemonById(id: id);
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Header
            Obx(() {
              return Container(
                height: height,
                decoration: BoxDecoration(
                  color: PokemonTypeToColor.getColor(
                          pokemonInfoController.pokemonSelected.type,
                          Colors.white)
                      .withOpacity(0.6),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringFunctions.capitalize(
                            pokemonInfoController.pokemonSelected.name ??
                                "no info"),
                        style: const TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            // Botón back
            Positioned(
              top: 5,
              left: 5,
              child: IconButton(
                onPressed: () {
                  Get.back();
                  pokemonInfoController.unselectPokemon();
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            // Botón shiny
            Positioned(
              top: 5,
              right: 5,
              child: IconButton(
                onPressed: () {
                  pokemonInfoController.changeFlagImage();
                },
                icon: const Icon(Icons.autorenew),
              ),
            ),
            // Contenido
            Positioned(
              child: Container(
                height: height * 0.65,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(50),
                  ),
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //Menu
                          PokemonInfoMenu(
                            pokemonInfoController: pokemonInfoController,
                          ),
                          //Contenido
                          const SizedBox(height: 20),
                          Obx(() {
                            if (!pokemonInfoController.flagMenu) {
                              // About
                              return PokemonInfoMenuAbout(
                                pokemonInfoController: pokemonInfoController,
                              );
                            } else {
                              // Stats
                              return Padding(
                                padding: const EdgeInsets.only(top: 50),
                                child: Transform.rotate(
                                  angle: 90 * math.pi / 180,
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        PokemonStatsChart(
                                          stats: pokemonInfoController
                                              .pokemonSelected.stats,
                                          angle: -90,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          })
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            // Imagen del pokemon
            Obx(() {
              if (pokemonInfoController.pokemonSelected.image == null) {
                return Positioned(
                  top: height * 0.3,
                  child: const CircularProgressIndicator(),
                );
              } else {
                return Positioned(
                  top: height * 0.13,
                  child: IgnorePointer(
                    ignoring: true,
                    child: Image.network(
                      pokemonInfoController.flagImage
                          ? pokemonInfoController.pokemonSelected.imageShiny!
                          : pokemonInfoController.pokemonSelected.image!,
                      height: height * 0.3,
                      width: height * 0.3,
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}

class PokemonInfoMenuAbout extends StatelessWidget {
  const PokemonInfoMenuAbout({
    super.key,
    required this.pokemonInfoController,
  });

  final PokemonInfoController pokemonInfoController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Obx(() {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Heigth:\t${pokemonInfoController.pokemonSelected.height ?? "no info"} m",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Weight:\t${pokemonInfoController.pokemonSelected.weight ?? "no info"} Kg",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                PokemonCardType(
                  type: pokemonInfoController.pokemonSelected.type,
                  fontSize: 18,
                ),
                PokemonCardType(
                  type: pokemonInfoController.pokemonSelected.subType,
                  fontSize: 18,
                ),
              ],
            )
          ],
        );
      }),
    );
  }
}

class PokemonInfoMenu extends StatelessWidget {
  const PokemonInfoMenu({
    Key? key,
    required this.pokemonInfoController,
  }) : super(key: key);
  final PokemonInfoController pokemonInfoController;
  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
          children: [
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  pokemonInfoController.changeFlagMenu(false);
                },
                child: PokemonInfoMenuItem(
                  text: "About",
                  borderColor: pokemonInfoController.flagMenu
                      ? Colors.transparent
                      : PokemonTypeToColor.getColor(
                          pokemonInfoController.pokemonSelected.type,
                          Colors.white),
                  textColor: pokemonInfoController.flagMenu
                      ? Colors.grey
                      : Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  pokemonInfoController.changeFlagMenu(true);
                },
                child: PokemonInfoMenuItem(
                  text: "Stats",
                  borderColor: pokemonInfoController.flagMenu
                      ? PokemonTypeToColor.getColor(
                          pokemonInfoController.pokemonSelected.type,
                          Colors.white)
                      : Colors.transparent,
                  textColor: pokemonInfoController.flagMenu
                      ? Colors.black
                      : Colors.grey,
                ),
              ),
            ),
          ],
        ));
  }
}

class PokemonInfoMenuItem extends StatelessWidget {
  const PokemonInfoMenuItem(
      {Key? key,
      required this.text,
      required this.borderColor,
      required this.textColor})
      : super(key: key);

  final Color textColor;
  final Color borderColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: borderColor,
            width: 3,
          ),
        ),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
