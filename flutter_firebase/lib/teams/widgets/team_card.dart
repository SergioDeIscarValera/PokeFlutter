import 'package:PokeFlutter/auth/utils/validators_utils.dart';
import 'package:PokeFlutter/routes/app_routes.dart';
import 'package:PokeFlutter/teams/models/team_dto.dart';
import 'package:PokeFlutter/teams/models/team_permissions.dart';
import 'package:PokeFlutter/teams/structure/controllers/teams_preview_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeamCard extends StatelessWidget {
  const TeamCard(
      {Key? key,
      required this.team,
      required this.email,
      required this.teamsPreviewController})
      : super(key: key);

  final TeamDto team;
  final String email;
  final double _avatarRadius = 20;
  final double _spacing = 5;
  final TeamsPreviewController teamsPreviewController;

  @override
  Widget build(BuildContext context) {
    bool isOwner = team.owner == email;
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.TEAMS_EDIT, arguments: {"team": team});
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isOwner ? Colors.grey[700] : Colors.grey[500],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  // Title
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      team.name!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // CircleAvatar, 3x3
                    Row(
                      children: [
                        SizedBox(
                          width: _avatarRadius + 2,
                        ),
                        Row(
                          children: [
                            for (int i = 0;
                                i <
                                    (team.pokemons!.length > 3
                                        ? 3
                                        : team.pokemons!.length);
                                i++)
                              Padding(
                                padding: EdgeInsets.only(right: _spacing),
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey[800],
                                  radius: _avatarRadius,
                                  backgroundImage: Image.network(
                                    team.pokemons!.keys.toList()[i].image!,
                                  ).image,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        for (int i = 3; i < team.pokemons!.length; i++)
                          Padding(
                            padding: EdgeInsets.only(right: _spacing),
                            child: CircleAvatar(
                              backgroundColor: Colors.grey[800],
                              radius: _avatarRadius,
                              backgroundImage: Image.network(
                                team.pokemons!.keys.toList()[i].image!,
                              ).image,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isOwner) ...[
            Positioned(
              right: 3,
              top: 3,
              child: GestureDetector(
                onTap: () {
                  openShareDialog(
                    context: context,
                    teamsPreviewController: teamsPreviewController,
                    uuid: team.UUID!,
                    name: team.name!,
                    controller: teamsPreviewController.emailController,
                    dropDownValue: teamsPreviewController.teamPermissions,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: const Icon(
                    Icons.share,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 3,
              bottom: 3,
              child: GestureDetector(
                onTap: () {
                  openDeleteDialog(
                    context: context,
                    teamsPreviewController: teamsPreviewController,
                    uuid: team.UUID!,
                    name: team.name!,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }

  Future openShareDialog({
    required BuildContext context,
    required TeamsPreviewController teamsPreviewController,
    required String uuid,
    required String name,
    required TextEditingController controller,
    required Rx<TeamPermissions> dropDownValue,
  }) =>
      showDialog(
        context: context,
        builder: (context) => Obx(() {
          final formKey = GlobalKey<FormState>();
          final FormValidator formValidator = FormValidator();
          return Form(
            key: formKey,
            child: AlertDialog(
              title: const Text("Share Team"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    validator: formValidator.isValidEmail,
                    decoration: InputDecoration(
                      hintText: "Write email to share...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    controller: controller,
                  ),
                  DropdownButton(
                    value: dropDownValue.value,
                    items: TeamPermissions.values.map((permission) {
                      return DropdownMenuItem(
                        value: permission,
                        child: Text(
                          TeamPermissionsUtils(permission).name,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      dropDownValue.value = value!;
                    },
                  ),
                ],
              ),
              actions: [
                Tooltip(
                  message: "Cancel operation",
                  child: IconButton(
                    onPressed: () {
                      controller.clear();
                      dropDownValue.value = TeamPermissions.values[0];
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.cancel,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Tooltip(
                  message: "Share team",
                  child: IconButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        teamsPreviewController.shareTeam(
                          teamUuid: uuid,
                          teamName: name,
                          callback: () {
                            controller.clear();
                            dropDownValue.value = TeamPermissions.values[0];
                            Get.snackbar(
                              "Success",
                              "Team shared",
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                          },
                        );

                        Get.back();
                      }
                    },
                    icon: const Icon(
                      Icons.share,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      );

  Future openDeleteDialog({
    required BuildContext context,
    required TeamsPreviewController teamsPreviewController,
    required String uuid,
    required String name,
  }) =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Delete Team"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Text("Are you sure you want to delete \"$name\" team?"),
          actions: [
            Tooltip(
              message: "Cancel operation",
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.grey,
                ),
              ),
            ),
            Tooltip(
              message: "Delete team",
              child: IconButton(
                onPressed: () {
                  teamsPreviewController.deleteTeam(uuid: uuid);
                  Get.back();
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      );
}
