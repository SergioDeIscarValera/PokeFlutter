import 'package:get/get.dart';
import 'package:namer_app/pokemon/structure/controllers/user_favorites_controller.dart';

class UserFavoritesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserFavoritesController>(() => UserFavoritesController());
  }
}