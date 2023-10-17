import 'package:get/get.dart';

class PokemonInfoController extends GetxController {
  RxBool flagMenu = false.obs; // false = about, true = stats
  RxBool flagImage = false.obs; // false = default, true = shiny

  void changeFlagMenu(bool newValue) {
    flagMenu.value = newValue;
  }

  void changeFlagImage() {
    flagImage.value = !flagImage.value;
  }
}
