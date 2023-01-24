import 'package:ecg_chat_app/models/account.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

part 'settings.g.dart';

enum ThemeColor {
  navy,
  mint,
  lavender,
  caramel,
  forest,
  wine,
  system;

  String asString() {
    switch (this) {
      case ThemeColor.system:
        return "System";
      case ThemeColor.navy:
        return "Navy";
      case ThemeColor.mint:
        return "Mint";
      case ThemeColor.lavender:
        return "Lavender";
      case ThemeColor.caramel:
        return "Caramel";
      case ThemeColor.forest:
        return "Forest";
      case ThemeColor.wine:
        return "Wine";
    }
  }

  Color toColor() {
    switch (this) {
      case ThemeColor.system:
        return Colors.blue[500]!;
      case ThemeColor.navy:
        return const Color(0xFF45A0F2);
      case ThemeColor.mint:
        return const Color(0xFF2AB8B8);
      case ThemeColor.lavender:
        return const Color(0xFFB4ABF5);
      case ThemeColor.caramel:
        return const Color(0xFFF78204);
      case ThemeColor.forest:
        return const Color(0xFF00FFA9);
      case ThemeColor.wine:
        return const Color(0xFF894771);
    }
  }
}

enum ThemeBrightness {
  light,
  dark,
  system;

  String asString() {
    switch (this) {
      case ThemeBrightness.system:
        return 'System';
      case ThemeBrightness.light:
        return 'Light';
      case ThemeBrightness.dark:
        return 'Dark';
    }
  }

  ThemeMode toThemeMode() {
    switch (this) {
      case ThemeBrightness.system:
        return ThemeMode.system;
      case ThemeBrightness.light:
        return ThemeMode.light;
      case ThemeBrightness.dark:
        return ThemeMode.dark;
    }
  }
}

enum DiskRetention {
  oneDay,
  threeDays,
  week,
  month,
  forever;

  String asString() {
    switch (this) {
      case DiskRetention.oneDay:
        return '1 Day';
      case DiskRetention.threeDays:
        return '3 Days';
      case DiskRetention.week:
        return '1 Week';
      case DiskRetention.month:
        return '1 Month';
      case DiskRetention.forever:
        return 'Forever';
    }
  }
}

@collection
class Settings extends ChangeNotifier {
  @ignore
  static Settings instance = Settings._();

  Settings._();

  factory Settings() => instance;

  Id id = 0;

  // Selected user account
  final account = IsarLink<Account>();

  // Theme related

  bool materialYou = true;

  @enumerated
  ThemeColor themeColor = ThemeColor.caramel;

  @enumerated
  ThemeBrightness themeBrightness = ThemeBrightness.system;

  // Data related

  @enumerated
  DiskRetention diskRetention = DiskRetention.week;

  // Theming

  static ThemeData themeData(Brightness brightness) => ThemeData(
        brightness: brightness,
        colorSchemeSeed: instance.themeColor.toColor(),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        ),
        useMaterial3: instance.materialYou,
      );

  static ThemeData get themeLight => themeData(Brightness.light);
  static ThemeData get themeDark => themeData(Brightness.dark);
  static ThemeMode get themeMode => instance.themeBrightness.toThemeMode();

  notify() => notifyListeners();
}
