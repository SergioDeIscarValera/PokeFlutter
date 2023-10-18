import 'package:PokeFlutter/pokemon/models/pokemon_full_info.dart';
import 'package:PokeFlutter/pokemon/services/pokemon_repository.dart';
import 'package:get/get.dart';

class PokemonInfoController extends GetxController {
  final RxBool _flagMenu = false.obs; // false = about, true = stats
  bool get flagMenu => _flagMenu.value;
  set flagMenu(bool newValue) => _flagMenu.value = newValue;

  final RxBool _flagImage = false.obs; // false = default, true = shiny
  bool get flagImage => _flagImage.value;
  set flagImage(bool newValue) => _flagImage.value = newValue;

  final Rx<PokemonFullInfo> _pokemonSelected = PokemonFullInfo().obs;
  PokemonFullInfo get pokemonSelected => _pokemonSelected.value;
  set pokemonSelected(PokemonFullInfo newValue) =>
      _pokemonSelected.value = newValue;

  void changeFlagMenu(bool newValue) {
    flagMenu = newValue;
  }

  void changeFlagImage() {
    flagImage = !flagImage;
  }

  Future<void> getFullPokemonById({required int id}) async {
    pokemonSelected = await PokemonRepository().getFullPokemonById(id: id);
  }

  void unselectPokemon() {
    pokemonSelected = PokemonFullInfo();
  }
}
