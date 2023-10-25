import 'package:PokeFlutter/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({
    super.key,
    required this.userName,
  });

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.grey[300],
        child: ListView(
          children: [
            DrawerHeader(
              padding: const EdgeInsets.only(top: 70),
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(64),
                ),
              ),
              child: Column(
                children: [
                  const Icon(Icons.person, size: 50, color: Colors.white),
                  Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            Builder(builder: (context) {
              return ListTile(
                leading: Icon(Icons.favorite, color: Colors.grey[700]),
                title: const Text(
                  "Favorites",
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  Scaffold.of(context).closeEndDrawer();
                  Get.toNamed(Routes.POKEMON_FAVORITES);
                },
              );
            }),
            Divider(
              color: Colors.grey[700],
            ),
            ListTile(
              leading: Icon(Icons.bar_chart, color: Colors.grey[700]),
              title: const Text(
                "Statistics",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Scaffold.of(context).closeEndDrawer();
                Get.toNamed(Routes.POKEMON_FAVORITES_STATISTICS);
              },
            ),
            Divider(
              color: Colors.grey[700],
            ),
            ListTile(
              leading: Icon(Icons.construction, color: Colors.grey[700]),
              title: const Text(
                "Teams Builder",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Scaffold.of(context).closeEndDrawer();
                Get.toNamed(Routes.TEAMS_PREVIEW);
              },
            ),
            Divider(
              color: Colors.grey[700],
            ),
            ListTile(
              leading: Icon(Icons.notifications, color: Colors.grey[700]),
              title: const Text(
                "Notifications",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Scaffold.of(context).closeEndDrawer();
                Get.toNamed(Routes.TEAMS_NOTIFICATIONS);
              },
            ),
            Divider(
              color: Colors.grey[700],
            ),
          ],
        ),
      ),
    );
  }
}
