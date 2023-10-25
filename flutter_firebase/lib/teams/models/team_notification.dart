class TeamNotification {
  String? inviter;
  String? uuidTeam;
  String? nameTeam;
  bool? permission;

  TeamNotification({
    required this.inviter,
    required this.uuidTeam,
    required this.permission,
    required this.nameTeam,
  });

  TeamNotification.fromJson(Map<String, dynamic> json) {
    inviter = json['user'];
    uuidTeam = json['teamUUID'];
    nameTeam = json['teamName'];
    permission = json['permissions'];
  }
}
