import 'package:flutter/material.dart';

class AppColors {
  static final AppColors _singleton = AppColors._internal();

  factory AppColors() {
    return _singleton;
  }

  AppColors._internal();

  final Color _primary = const Color(0xFF78c2ad);
  final Color _secondary = const Color(0xFFf3969a);
  final Color _suscess = const Color(0xFF56cc9d);
  final Color _info = const Color(0xFF6cc3d5);
  final Color _warning = const Color(0xFFffce67);
  final Color _danger = const Color(0xFFff7851);
  final Color _light = const Color(0xFFf8f9fa);
  final Color _dark = const Color(0xFF343a40);

  bool _isDark = false;

  static bool get isDark => _singleton._isDark;

  static set isDark(bool value) {
    _singleton._isDark = value;
  }

  static Color get primary {
    return _singleton._primary;
  }

  static Color get secondary {
    return _singleton._secondary;
  }

  static Color get suscess {
    return _singleton._suscess;
  }

  static Color get info {
    return _singleton._info;
  }

  static Color get warning {
    return _singleton._warning;
  }

  static Color get danger {
    return _singleton._danger;
  }

  static Color get light {
    return _singleton._isDark ? _singleton._dark : _singleton._light;
  }

  static Color get dark {
    return _singleton._isDark ? _singleton._light : _singleton._dark;
  }
}