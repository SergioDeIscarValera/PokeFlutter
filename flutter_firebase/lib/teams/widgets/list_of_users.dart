import 'package:PokeFlutter/teams/models/team_dto.dart';
import 'package:PokeFlutter/teams/models/team_permissions.dart';
import 'package:PokeFlutter/teams/structure/controllers/teams_edit_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListOfUsers extends StatelessWidget {
  const ListOfUsers(
      {Key? key,
      required this.teamsEditController,
      required this.users,
      required this.team})
      : super(key: key);
  final TeamsEditController teamsEditController;
  final RxMap<String, bool> users;
  final TeamDto team;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (teamsEditController.teamPermissions.isNotEmpty) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey[600],
          ),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              const Text(
                "Users/Permissions:",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 15),
              ListView.builder(
                itemCount: users.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => ItemListOfUsers(
                  users: users,
                  teamsEditController: teamsEditController,
                  team: team,
                  index: index,
                ),
              )
            ],
          ),
        );
      } else {
        return const SizedBox();
      }
    });
  }
}

class ItemListOfUsers extends StatelessWidget {
  const ItemListOfUsers({
    super.key,
    required this.users,
    required this.teamsEditController,
    required this.team,
    required this.index,
  });

  final RxMap<String, bool> users;
  final TeamsEditController teamsEditController;
  final TeamDto team;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[200],
      ),
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Text(users.entries.elementAt(index).key))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: DropdownButton(
                  alignment: Alignment.center,
                  isExpanded: true,
                  value: users.entries.elementAt(index).value
                      ? TeamPermissions.readWrite
                      : TeamPermissions.read,
                  onChanged: (value) {
                    teamsEditController.changePermissionLocal(
                      emailUser: users.entries.elementAt(index).key,
                      permission: value!,
                    );
                  },
                  items: TeamPermissions.values
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(TeamPermissionsUtils(e).name),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(width: 15),
              GestureDetector(
                onTap: () {
                  teamsEditController.changePermission(
                    emailOwner: team.owner!,
                    emailUser: users.entries.elementAt(index).key,
                    uuid: team.UUID!,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.grey[700],
                  ),
                  child: Icon(
                    Icons.save,
                    color: Colors.grey[200],
                  ),
                ),
              ),
              const SizedBox(width: 15),
              GestureDetector(
                onTap: () {
                  teamsEditController.removeUser(
                    emailOwner: team.owner!,
                    emailUser: users.entries.elementAt(index).key,
                    uuid: team.UUID!,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.grey[700],
                  ),
                  child: Icon(
                    Icons.delete,
                    color: Colors.grey[200],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
