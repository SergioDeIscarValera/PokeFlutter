import 'package:get/get.dart';
import 'package:namer_app/auth/structure/controllers/auth_controller.dart';

class AuthBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}