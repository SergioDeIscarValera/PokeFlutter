import 'package:PokeFlutter/pokemon/structure/controllers/pokemon_controller.dart';
import 'package:PokeFlutter/pokemon/structure/controllers/pokemon_info_controller.dart';
import 'package:PokeFlutter/pokemon/utils/pokemon_type_to_color.dart';
import 'package:PokeFlutter/pokemon/widgets/pokemon_card_type.dart';
import 'package:PokeFlutter/pokemon/widgets/pokemon_stats_chart.dart';
import 'package:PokeFlutter/utils/string_funtions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PokemonInfo extends StatelessWidget {
  const PokemonInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PokemonController pokemonController = Get.find();
    PokemonInfoController pokemonInfoController = Get.find();

    var id = Get.arguments["id"];
    pokemonController.getFullPokemonById(id: id);
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
                  color: Color(PokemonTypeToColor.getColor(pokemonController
                              .pokemonSelected.value.type
                              .toString()) ??
                          0xFFFFFFFF)
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
                            pokemonController.pokemonSelected.value.name ??
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
                  pokemonController.unselectPokemon();
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ),
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
                            pokemonController: pokemonController,
                            pokemonInfoController: pokemonInfoController,
                          ),
                          //Contenido
                          const SizedBox(height: 20),
                          Obx(() {
                            if (!pokemonInfoController.flagMenu.value) {
                              // About
                              return PokemonInfoMenuAbout(
                                pokemonController: pokemonController,
                                pokemonInfoController: pokemonInfoController,
                              );
                            } else {
                              // Stats
                              return SizedBox(
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    PokemonStatsChart(
                                      stats: pokemonController
                                          .pokemonSelected.value.stats,
                                    )
                                  ],
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
              if (pokemonController.pokemonSelected.value.image == null) {
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
                      pokemonInfoController.flagImage.value
                          ? pokemonController.pokemonSelected.value.imageShiny!
                          : pokemonController.pokemonSelected.value.image!,
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
    required this.pokemonController,
    required this.pokemonInfoController,
  });

  final PokemonController pokemonController;
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
              "Heigth:\t${pokemonController.pokemonSelected.value.height ?? "no info"} m",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Weight:\t${pokemonController.pokemonSelected.value.weight ?? "no info"} Kg",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                PokemonCardType(
                  type: pokemonController.pokemonSelected.value.type,
                  fontSize: 18,
                ),
                PokemonCardType(
                  type: pokemonController.pokemonSelected.value.subType,
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
    required this.pokemonController,
    required this.pokemonInfoController,
  }) : super(key: key);

  final PokemonController pokemonController;
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
                  borderColor: pokemonInfoController.flagMenu.value
                      ? Colors.transparent
                      : Color(PokemonTypeToColor.getColor(pokemonController
                              .pokemonSelected.value.type
                              .toString()) ??
                          0xFFFFFFFF),
                  textColor: pokemonInfoController.flagMenu.value
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
                  borderColor: pokemonInfoController.flagMenu.value
                      ? Color(PokemonTypeToColor.getColor(pokemonController
                              .pokemonSelected.value.type
                              .toString()) ??
                          0xFFFFFFFF)
                      : Colors.transparent,
                  textColor: pokemonInfoController.flagMenu.value
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
