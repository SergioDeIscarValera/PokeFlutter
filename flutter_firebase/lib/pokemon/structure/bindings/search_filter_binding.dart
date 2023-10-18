import 'package:PokeFlutter/pokemon/structure/controllers/search_filter_controller.dart';
import 'package:get/get.dart';

class SearchFilterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchFilterController>(() => SearchFilterController());
  }
}
