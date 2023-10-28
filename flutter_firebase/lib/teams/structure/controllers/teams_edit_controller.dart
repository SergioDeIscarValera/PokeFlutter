import 'package:PokeFlutter/pokemon/models/pokemon_dto.dart';
import 'package:PokeFlutter/pokemon/models/pokemon_filter_class.dart';
import 'package:PokeFlutter/pokemon/models/pokemon_generations.dart';
import 'package:PokeFlutter/pokemon/models/pokemon_stats.dart';
import 'package:PokeFlutter/pokemon/models/pokemon_type.dart';
import 'package:PokeFlutter/pokemon/services/pokemon_repository.dart';
import 'package:PokeFlutter/pokemon/structure/controllers/pokemon_controller.dart';
import 'package:PokeFlutter/teams/models/team_dto.dart';
import 'package:PokeFlutter/teams/models/team_permissions.dart';
import 'package:PokeFlutter/teams/services/teams_firebase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeamsEditController extends GetxController {
  RxMap<PokemonDto, List<String>> team = <PokemonDto, List<String>>{}.obs;
  final RxMap<int, List<String>> _allMoves = <int, List<String>>{}.obs;
  Map<int, List<String>> get allMoves => _allMoves;

  RxMap<String, bool> teamPermissions = <String, bool>{}.obs;

  TextEditingController searchController = TextEditingController();
  final Rx<PokemonType?> typeFilter = Rx<PokemonType?>(null);
  final Rx<PokemonType?> subTypeFilter = Rx<PokemonType?>(null);

  final RxBool moreFilterIsOpen = false.obs;

  RxMap<PokemonStats, RangeValues> statsRangeValues =
      <PokemonStats, RangeValues>{}.obs;

  final Rx<PokemonGenerations?> generationFilter =
      Rx<PokemonGenerations?>(null);

  PokemonController pokemonController = Get.find();

  RxString moveToAdd = "".obs;

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
    team.listen((newTeam) {
      updateMoves(team: newTeam);
    });
    super.onReady();
  }

  void setListeners(TeamDto argumentTeam, String email) {
    TeamsFirebase().setListeneOwner(
      email: email,
      callback: (team) {
        this.team.value = team
            .firstWhere((element) => element.UUID == argumentTeam.UUID)
            .pokemons!;
        teamPermissions.value = team
            .firstWhere((element) => element.UUID == argumentTeam.UUID)
            .users!;
      },
    );
  }

  void addPokemon(String email, String uuidTeam, PokemonDto pokemon) {
    TeamsFirebase().addPokemon(
      email: email,
      uuidTeam: uuidTeam,
      pokemon: pokemon,
    );
  }

  void removePokemon(String email, String uuidTeam, PokemonDto pokemon) {
    TeamsFirebase().removePokemon(
      email: email,
      uuidTeam: uuidTeam,
      pokemon: pokemon,
    );
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
    var isFiltering = searchController.value.text.isNotEmpty ||
        typeFilter.value != null ||
        subTypeFilter.value != null ||
        statsRangeValues.values
            .any((element) => element.start != 0 || element.end != 255) ||
        generationFilter.value != null;
    pokemonController.filterAllPokemons(
        filter: PokemonFilter(
          textFild: searchController.value.text,
          type: typeFilter.value,
          subType: subTypeFilter.value,
          stats: statsRangeValues.value,
          generation: generationFilter.value,
        ),
        isFiltering: isFiltering);
  }

  void changePermission({
    required String emailOwner,
    required String emailUser,
    required String uuid,
  }) {
    TeamsFirebase().changePermission(
      emailOwner: emailOwner,
      emailUser: emailUser,
      newPermissions: teamPermissions.value[emailUser]!,
      uuid: uuid,
      onChange: () {
        Get.snackbar(
          "Success",
          "Permission changed successfully",
          backgroundColor: Colors.green.withOpacity(0.2),
        );
      },
    );
  }

  void changePermissionLocal({
    required String emailUser,
    required TeamPermissions permission,
  }) {
    teamPermissions[emailUser] = permission.permission;
  }

  void removeUser({
    required String emailOwner,
    required String emailUser,
    required String uuid,
  }) {
    TeamsFirebase().removeUser(
      emailOwner: emailOwner,
      emailUser: emailUser,
      uuid: uuid,
      onRemove: () {
        Get.snackbar(
          "Success",
          "User removed successfully",
          backgroundColor: Colors.green.withOpacity(0.2),
        );
      },
    );
  }

  void addMove(
      {required String email,
      required String uuidTeam,
      required PokemonDto pokemon}) {
    TeamsFirebase().addMove(
      email: email,
      uuidTeam: uuidTeam,
      pokemon: pokemon,
      move: moveToAdd.value,
    );
  }

  void removeMove({
    required String email,
    required String uuidTeam,
    required PokemonDto pokemon,
    required String move,
  }) {
    TeamsFirebase().removeMove(
      email: email,
      uuidTeam: uuidTeam,
      pokemon: pokemon,
      move: move,
    );
  }

  void updateMoves({required Map<PokemonDto, List<String>> team}) async {
    // Cuando se actualiza el equipo hay que actualizar la lista de movimientos pero solo hay que cambiar los que no esten registrados para no llamar tantas veces a la api
    for (var pokemon in team.keys) {
      var id = pokemon.id!;
      if (!_allMoves.containsKey(id)) {
        var moves = await PokemonRepository().getMovesById(id: id);
        _allMoves[id] = moves;
      }
    }
    if (_allMoves.length != team.length) {
      var teamId = team.keys.map((e) => e.id).toList();
      for (var pokemon in _allMoves.keys) {
        if (!teamId.contains(pokemon)) {
          _allMoves.remove(pokemon);
        }
      }
    }
    //Remover los movimientos que ya estan en el equipo
    for (var pokemon in team.keys) {
      for (var move in team[pokemon]!) {
        _allMoves[pokemon.id!]!.remove(move.toLowerCase());
      }
    }
    //Ordenar los movimientos alfabeticamente
    for (var pokemon in _allMoves.keys) {
      _allMoves[pokemon]!.sort();
    }
  }
}
