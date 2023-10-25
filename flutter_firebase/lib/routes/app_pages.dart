import 'package:PokeFlutter/auth/pages/login_page.dart';
import 'package:PokeFlutter/auth/pages/register_page.dart';
import 'package:PokeFlutter/pokemon/pages/pokemon_favorites.dart';
import 'package:PokeFlutter/pokemon/pages/pokemon_favorites_statistics.dart';
import 'package:PokeFlutter/pokemon/pages/pokemon_home.dart';
import 'package:PokeFlutter/pokemon/pages/pokemon_info.dart';
import 'package:PokeFlutter/teams/pages/teams_edit.dart';
import 'package:PokeFlutter/teams/pages/teams_notifications.dart';
import 'package:PokeFlutter/teams/pages/teams_preview.dart';
import 'package:PokeFlutter/pokemon/structure/bindings/pokemon_binding.dart';
import 'package:PokeFlutter/pokemon/structure/bindings/pokemon_favorites_statistics_binding.dart';
import 'package:PokeFlutter/pokemon/structure/bindings/pokemon_info_binding.dart';
import 'package:PokeFlutter/pokemon/structure/bindings/search_filter_binding.dart';
import 'package:PokeFlutter/pokemon/structure/bindings/user_favorites_binding.dart';
import 'package:PokeFlutter/teams/structure/bindings/teams_edit_binding.dart';
import 'package:PokeFlutter/teams/structure/bindings/teams_notifications_binding.dart';
import 'package:PokeFlutter/teams/structure/bindings/teams_preview_binding.dart';
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
      bindings: [UserFavoritesBinding(), SearchFilterBinding()],
    ),
    GetPage(
      name: Routes.POKEMON_FAVORITES,
      page: () => PokemonFavorites(),
    ),
    GetPage(
      name: Routes.POKEMON_INFO,
      page: () => const PokemonInfo(),
      binding: PokemonInfoBinding(),
    ),
    GetPage(
      name: Routes.POKEMON_FAVORITES_STATISTICS,
      page: () => const PokemonFavoritesStatistics(),
      binding: PokemonFavoritesStatisticsBinding(),
    ),
    GetPage(
      name: Routes.TEAMS_PREVIEW,
      page: () => TeamsPreview(),
      binding: TeamsPreviewBinding(),
    ),
    GetPage(
      name: Routes.TEAMS_NOTIFICATIONS,
      page: () => const TeamsNotifications(),
      binding: TeamsNotificationsBinding(),
    ),
    GetPage(
      name: Routes.TEAMS_EDIT,
      page: () => TeamsEdit(),
      binding: TeamsEditBinding(),
    )
  ];
}
