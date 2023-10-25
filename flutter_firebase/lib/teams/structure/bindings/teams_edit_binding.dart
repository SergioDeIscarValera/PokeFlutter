import 'package:PokeFlutter/teams/structure/controllers/teams_edit_controller.dart';
import 'package:get/get.dart';

class TeamsEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TeamsEditController>(() => TeamsEditController());
  }
}
