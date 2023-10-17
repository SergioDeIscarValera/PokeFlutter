import 'package:PokeFlutter/auth/pages/login_page.dart';
import 'package:PokeFlutter/auth/pages/register_page.dart';
import 'package:PokeFlutter/pokemon/pages/pokemon_favorites.dart';
import 'package:PokeFlutter/pokemon/pages/pokemon_home.dart';
import 'package:PokeFlutter/pokemon/pages/pokemon_info.dart';
import 'package:PokeFlutter/pokemon/structure/bindings/pokemon_binding.dart';
import 'package:PokeFlutter/pokemon/structure/bindings/pokemon_info_binding.dart';
import 'package:PokeFlutter/pokemon/structure/bindings/user_favorites_binding.dart';
import 'package:get/get.dart';

import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginPage(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => RegisterPage(),
    ),
    GetPage(
      name: Routes.POKEMON_HOME,
      page: () => PokemonHome(),
      binding: PokemonBinding(),
      bindings: [UserFavoritesBinding()],
    ),
    GetPage(
      name: Routes.POKEMON_FAVORITES,
      page: () => PokemonFavorites(),
    ),
    GetPage(
      name: Routes.POKEMON_INFO,
      page: () => const PokemonInfo(),
      binding: PokemonInfoBinding(),
    )
  ];
}
