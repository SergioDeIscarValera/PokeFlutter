enum TeamPermissions {
  read,
  readWrite,
}

extension TeamPermissionsUtils on TeamPermissions {
  String get name {
    switch (this) {
      case TeamPermissions.read:
        return "Only view";
      case TeamPermissions.readWrite:
        return "Can edit";
    }
  }

  bool get permission {
    switch (this) {
      case TeamPermissions.read:
        return false;
      case TeamPermissions.readWrite:
        return true;
    }
  }
}
