import 'package:PokeFlutter/teams/structure/controllers/teams_notifications_controller.dart';
import 'package:get/get.dart';

class TeamsNotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TeamsNotificationsController>(
      () => TeamsNotificationsController(),
    );
  }
}
