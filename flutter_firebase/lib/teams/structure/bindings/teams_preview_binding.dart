import 'package:PokeFlutter/teams/structure/controllers/teams_preview_controller.dart';
import 'package:get/get.dart';

class TeamsPreviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TeamsPreviewController>(() => TeamsPreviewController());
  }
}
