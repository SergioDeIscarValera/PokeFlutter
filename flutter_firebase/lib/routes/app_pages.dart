import 'package:get/get.dart';
import 'package:namer_app/auth/pages/loading_page.dart';
import 'package:namer_app/auth/pages/login_page.dart';
import 'package:namer_app/auth/pages/register_page.dart';
import 'package:namer_app/pokemon/pages/pokemon_favorites.dart';
import 'package:namer_app/pokemon/pages/pokemon_home.dart';
import 'package:namer_app/pokemon/structure/bindings/pokemon_binding.dart';
import 'package:namer_app/pokemon/structure/bindings/user_favorites_binding.dart';

import 'app_routes.dart';

class AppPages{
  static final routes = [
    GetPage(
      name: Routes.LOADING, 
      page: () => const LoadingPage(),
    ),
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
      bindings: [
        UserFavoritesBinding()
      ]
    ),
    GetPage(
      name: Routes.POKEMON_FAVORITES, 
      page: () => PokemonFavorites(),
    )
  ];
}