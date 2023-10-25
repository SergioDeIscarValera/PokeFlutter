import 'package:PokeFlutter/pokemon/models/pokemon_dto.dart';
import 'package:PokeFlutter/pokemon/services/pokemon_repository.dart';
import 'package:PokeFlutter/teams/models/team_dto.dart';
import 'package:PokeFlutter/teams/models/team_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class TeamsFirebase {
  //#region Teams

  /// Función que obtiene los equipos de un usuario, tanto los que ha creado como los que ha aceptado
  /// @param email Email del usuario
  /// @return Lista de equipos
  Future<List<TeamDto>> getTeams({required String email}) async {
    var ownTeams = await getOwnTeams(email: email);
    var acceptedTeams = await getAcceptedTeams(email: email);
    return [...ownTeams, ...acceptedTeams];
  }

  /// Función que obtiene los equipos que ha creado un usuario
  /// @param email Email del usuario
  /// @return Lista de equipos
  Future<List<TeamDto>> getOwnTeams({required String email}) async {
    return await FirebaseFirestore.instance
        .collection("teams")
        .doc(email)
        .get()
        .then((value) {
      if (!value.exists) return <TeamDto>[];
      if (value.data()?["owner"] == null) return <TeamDto>[];
      final teamsOwner = value.data()?["owner"] as List<dynamic>;
      return teamsOwner
          .map((teamOwner) => TeamDto.fromJson(teamOwner, email))
          .toList();
    });
  }

  /// Función que obtiene los equipos que ha aceptado un usuario
  /// @param email Email del usuario
  /// @return Lista de equipos
  Future<List<TeamDto>> getAcceptedTeams({required String email}) async {
    return await FirebaseFirestore.instance
        .collection("teams")
        .doc(email)
        .get()
        .then((value) {
      if (!value.exists) return <TeamDto>[];
      if (value.data()?["accepted"] == null) return <TeamDto>[];
      final teamsAccepted = value.data()?["accepted"] as List<dynamic>;
      List<Future<TeamDto>> futureGetTeams = teamsAccepted
          .map((acceptedRow) async => await _getTeamByEmailAndId(
              email: acceptedRow.entries.first.key,
              uuid: acceptedRow.entries.first.value))
          .map((futureTeam) async => (await futureTeam)!)
          .toList();
      return Future.wait(futureGetTeams);
    });
  }

  /// Función que obtiene un equipo a partir de su email (propietario) y su uuid
  /// @param email Email del usuario propietario del equipo
  /// @param uuid UUID del equipo
  /// @return Equipo
  Future<TeamDto?> _getTeamByEmailAndId(
      {required String email, required String uuid}) async {
    return await getOwnTeams(email: email)
        .then((teams) => teams.firstWhereOrNull((team) => team.UUID == uuid));
  }

  Future<void> createTeam({
    required String email,
    required TeamDto team,
  }) async {
    String uuid = const Uuid().v4();
    try {
      await FirebaseFirestore.instance.collection("teams").doc(email).update(
        {
          "owner": FieldValue.arrayUnion([
            {
              "UUID": uuid,
              "name": team.name,
              "pokemons": team.pokemons!.map((e) => e.id).toList(),
              "invited": team.users
            }
          ])
        },
      );
    } catch (e) {
      // Si falla al actualizar hay que crear el documento
      await FirebaseFirestore.instance.collection("teams").doc(email).set(
        {
          "owner": FieldValue.arrayUnion([
            {
              "UUID": uuid,
              "name": team.name,
              "pokemons": team.pokemons!.map((e) => e.id).toList(),
              "invited": team.users
            }
          ])
        },
      );
    }
  }

  /*Future<int> _getLastId({required String email}) async {
    return await FirebaseFirestore.instance
        .collection("teams")
        .doc(email)
        .get()
        .then((value) {
      if (!value.exists) return 0;
      final teamsOwner = value.data()?["owner"] as List<dynamic>;
      return teamsOwner.last["id"] ?? 0;
    });
  }*/

  Future<void> deleteTeam({required String email, required String uuid}) async {
    var allTeams = await getOwnTeams(email: email);
    var removeTeam = allTeams.firstWhere((element) => element.UUID == uuid);
    await _removeAccepts(
        users: removeTeam.users!, emailSender: email, uuid: uuid);
    allTeams.remove(removeTeam);
    await FirebaseFirestore.instance.collection("teams").doc(email).update({
      "owner": allTeams
          .map((e) => {
                "UUID": e.UUID,
                "name": e.name,
                "pokemons": e.pokemons!.map((e) => e.id).toList(),
                "invited": e.users,
              })
          .toList(),
    });
  }

  Future<void> _removeAccepts(
      {required Map<String, bool> users,
      required String emailSender,
      required String uuid}) async {
    var futureRemoveAccepts = users.entries
        .map((user) async => await _removeAccept(
              emailSender: emailSender,
              emailReciver: user.key,
              uuidTeam: uuid,
            ))
        .toList();
    await Future.wait(futureRemoveAccepts);
  }

  Future<void> _removeAccept({
    required String emailSender,
    required String emailReciver,
    required String uuidTeam,
  }) async {
    List<Map<String, String>> allAccepts = await FirebaseFirestore.instance
        .collection("teams")
        .doc(emailReciver)
        .get()
        .then((value) {
      var accepted = value.data()?["accepted"] as List<dynamic>;
      return accepted
          .map((acceptedRow) => {
                acceptedRow.entries.first.key.toString():
                    acceptedRow.entries.first.value.toString()
              })
          .toList();
    });
    allAccepts.removeWhere((element) =>
        element.keys.first == emailSender && element.values.first == uuidTeam);
    await FirebaseFirestore.instance
        .collection("teams")
        .doc(emailReciver)
        .update({
      "accepted": allAccepts,
    });
  }

  Future<void> setListeneOwner(
      {required String email,
      required Function(List<TeamDto>) callback}) async {
    FirebaseFirestore.instance
        .collection("teams")
        .doc(email)
        .snapshots()
        .listen((event) {
      final teamsOwner = event.data()?["owner"] as List<dynamic>;
      var ownerList = teamsOwner
          .map((teamOwner) => TeamDto.fromJson(teamOwner, email))
          .toList();
      getAcceptedTeams(email: email).then((acceptedList) {
        callback.call([...ownerList, ...acceptedList]);
      });
    });
  }

  Future<void> changePermission({
    required String emailOwner,
    required String emailUser,
    required String uuid,
    required bool newPermissions,
    required Function onChange,
  }) async {
    await FirebaseFirestore.instance
        .collection("teams")
        .doc(emailOwner)
        .get()
        .then((value) {
      var teamsOwner = value.data()?["owner"] as List<dynamic>;
      var team = teamsOwner.firstWhere((element) => element["UUID"] == uuid);
      team["invited"][emailUser] = newPermissions;
      FirebaseFirestore.instance
          .collection("teams")
          .doc(emailOwner)
          .update({"owner": teamsOwner});
    });
    onChange.call();
  }

  Future<void> removeUser({
    required String emailOwner,
    required String emailUser,
    required String uuid,
    required Function onRemove,
  }) async {
    //Remove from accepted
    await FirebaseFirestore.instance
        .collection("teams")
        .doc(emailUser)
        .get()
        .then((value) {
      var teamsAccepted = value.data()?["accepted"] as List<dynamic>;
      teamsAccepted.removeWhere((element) =>
          element.entries.first.key == emailOwner &&
          element.entries.first.value == uuid);
      FirebaseFirestore.instance
          .collection("teams")
          .doc(emailUser)
          .update({"accepted": teamsAccepted});
    });

    //Remove from owner
    await FirebaseFirestore.instance
        .collection("teams")
        .doc(emailOwner)
        .get()
        .then((value) {
      var teamsOwner = value.data()?["owner"] as List<dynamic>;
      var team = teamsOwner.firstWhere((element) => element["UUID"] == uuid);
      team["invited"].remove(emailUser);
      FirebaseFirestore.instance
          .collection("teams")
          .doc(emailOwner)
          .update({"owner": teamsOwner});
    });
    onRemove.call();
  }

  //#endregion

  //#region Invitations

  /// Función que pone a la escucha de los cambios en las notificaciones de un usuario
  /// @param email Email del usuario
  /// @param callback Función que se ejecuta cuando hay cambios en las notificaciones
  void setListenerNotifications({
    required String email,
    required Function(List<TeamNotification>) callback,
  }) {
    FirebaseFirestore.instance
        .collection("notifications")
        .doc(email)
        .snapshots()
        .listen((event) {
      final invited = event.data()?["invited"] as List<dynamic>;

      callback.call(invited
          .map((invitedRow) => TeamNotification.fromJson(invitedRow))
          .toList());
    });
  }

  /// Función que envía una invitación a un usuario
  /// @param emailSender Email del usuario que envía la invitación
  /// @param emailReceiver Email del usuario que recibe la invitación
  /// @param teamUuid UUID del equipo
  /// @param permission Permisos que se le otorgan al usuario
  Future<void> sendInvitation({
    required String emailSender,
    required String emailReceiver,
    required String teamUuid,
    required String teamName,
    required bool permission,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection("notifications")
          .doc(emailReceiver)
          .update({
        "invited": FieldValue.arrayUnion([
          {
            "user": emailSender,
            "teamUUID": teamUuid,
            "teamName": teamName,
            "permissions": permission,
          }
        ])
      });
    } catch (e) {
      // Si falla crear el documento
      await FirebaseFirestore.instance
          .collection("notifications")
          .doc(emailReceiver)
          .set({
        "invited": FieldValue.arrayUnion([
          {
            "user": emailSender,
            "teamUUID": teamUuid,
            "teamName": teamName,
            "permissions": permission,
          }
        ])
      });
    }
  }

  /// Función que acepta una invitación
  /// @param emailSender  Email del usuario que envía la invitación
  /// @param emailReciver Email del usuario que acepta la invitación
  /// @param teamUuid UUID del equipo
  Future<void> acceptInvitation({
    required String emailSender,
    required String emailReciver,
    required String teamUuid,
    required Function onSucces,
  }) async {
    // Eliminar de la lista de invitaciones del emailReciver
    var permission = await _removeInvitation(
      emailRevicer: emailReciver,
      emailSender: emailSender,
      teamUuid: teamUuid,
    );
    var team = await _getTeamByEmailAndId(email: emailSender, uuid: teamUuid);

    if (team == null) {
      Get.snackbar("Error", "El equipo no existe");
      return;
    }

    // Añadir a la lista de aceptados del emailReciver
    try {
      await FirebaseFirestore.instance
          .collection("teams")
          .doc(emailReciver)
          .update({
        "accepted": FieldValue.arrayUnion([
          {
            emailSender: teamUuid,
          }
        ])
      });
    } catch (e) {
      // Si falla crear el documento
      await FirebaseFirestore.instance
          .collection("teams")
          .doc(emailReciver)
          .set({
        "accepted": FieldValue.arrayUnion([
          {
            emailSender: teamUuid,
          }
        ])
      });
      onSucces.call();
    }
    // Y añadir a la lista de miembros del equipo del emailSender
    await _addMemberTeam(
      emailOwner: emailSender,
      emailInviter: emailReciver,
      uuidTeam: teamUuid,
      permission: permission,
    );
  }

  /// Función que rechaza una invitación
  /// @param emailOwner Email del usuario propietario del equipo (el que ha enviado la invitación)
  /// @param emailReciver Email del usuario que ha enviado la invitación
  /// @param teamUuid Uuid del equipo
  Future<void> declineInvitation({
    required String emailOwner,
    required String emailReciver,
    required String teamUuid,
    required Function onSucces,
  }) async {
    await _removeInvitation(
      emailRevicer: emailReciver,
      emailSender: emailOwner,
      teamUuid: teamUuid,
    );
    onSucces.call();
  }

  /// Función que elimina una invitación
  /// @param emailRevicer Email del usuario que tiene la invitación
  /// @param emailSender Email del usuario que ha enviado la invitación
  /// @param teamUuid UUID del equipo
  Future<bool> _removeInvitation({
    required String emailRevicer,
    required String emailSender,
    required String teamUuid,
  }) async {
    var invitations = await _getAllIvitations(email: emailRevicer);
    var invitation = invitations.firstWhere((invitedRow) =>
        invitedRow.inviter == emailSender && invitedRow.uuidTeam == teamUuid);

    invitations.remove(invitation);

    await FirebaseFirestore.instance
        .collection("notifications")
        .doc(emailRevicer)
        .set({
      "invited": invitations
          .map((e) => {
                "user": e.inviter,
                "teamUUID": e.uuidTeam,
                "teamName": e.nameTeam,
                "permissions": e.permission,
              })
          .toList(),
    });
    return invitation.permission!;
  }

  Future<List<TeamNotification>> _getAllIvitations(
      {required String email}) async {
    return await FirebaseFirestore.instance
        .collection("notifications")
        .doc(email)
        .get()
        .then((value) {
      final invited = value.data()?["invited"] as List<dynamic>;
      return invited
          .map((invitedRow) => TeamNotification.fromJson(invitedRow))
          .toList();
    });
  }

  /// Función que añade un miembro a un equipo
  /// @param emailOwner Email del usuario propietario del equipo
  /// @param emailInviter Email del usuario que ha sido invitado
  /// @param uuidTeam UUID del equipo
  /// @param permission Permisos que se le otorgan al usuario
  Future<void> _addMemberTeam({
    required String emailOwner,
    required String emailInviter,
    required String uuidTeam,
    required bool permission,
  }) async {
    // Añadir una nueva entrada al array invited dentro del arrayowner donde el UUID sea uuidTeam
    var allTeams = await getOwnTeams(email: emailOwner);
    allTeams
        .where((element) => element.UUID == uuidTeam)
        .first
        .users
        ?.addAll({emailInviter: permission});
    await FirebaseFirestore.instance
        .collection("teams")
        .doc(emailOwner)
        .update({
      "owner": allTeams
          .map((e) => {
                "UUID": e.UUID,
                "name": e.name,
                "pokemons": e.pokemons!.map((e) => e.id).toList(),
                "invited": e.users,
              })
          .toList(),
    });
  }

  //#endregion

  //#region Pokemons

  /// Función que añade un pokemon a un equipo
  /// @param email Email del usuario propietario del equipo
  /// @param uuidTeam UUID del equipo
  /// @param pokemonId Id del pokemon que se va a añadir
  Future<void> addPokemon({
    required String email,
    required String uuidTeam,
    required PokemonDto pokemon,
  }) async {
    var allTeams = await getOwnTeams(email: email);
    allTeams
        .where((element) => element.UUID == uuidTeam)
        .first
        .pokemons
        ?.add(pokemon);
    await FirebaseFirestore.instance.collection("teams").doc(email).update({
      "owner": allTeams
          .map((e) => {
                "UUID": e.UUID,
                "name": e.name,
                "pokemons": e.pokemons!.map((e) => e.id).toList(),
                "invited": e.users,
              })
          .toList(),
    });
  }

  /// Función que elimina un pokemon a un equipo
  /// @param email Email del usuario propietario del equipo
  /// @param uuidTeam UUID del equipo
  /// @param pokemonId Id del pokemon que se va a añadir
  Future<void> removePokemon({
    required String email,
    required String uuidTeam,
    required PokemonDto pokemon,
  }) async {
    var allTeams = await getOwnTeams(email: email);
    allTeams
        .where((element) => element.UUID == uuidTeam)
        .first
        .pokemons
        ?.removeWhere((element) => element.id == pokemon.id);
    await FirebaseFirestore.instance.collection("teams").doc(email).update({
      "owner": allTeams
          .map((e) => {
                "UUID": e.UUID,
                "name": e.name,
                "pokemons": e.pokemons!.map((e) => e.id).toList(),
                "invited": e.users,
              })
          .toList(),
    });
  }

  //#endregion
}
