import 'package:PokeFlutter/pokemon/structure/controllers/user_favorites_controller.dart';
import 'package:get/get.dart';

class UserFavoritesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserFavoritesController>(() => UserFavoritesController());
  }
}
