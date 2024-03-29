import 'package:ecg_chat_app/models/account.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../utils/api.dart';

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

  String prettyString() {
    switch (this) {
      case DiskRetention.oneDay:
        return 'for 1 day';
      case DiskRetention.threeDays:
        return 'for 3 days';
      case DiskRetention.week:
        return 'for 1 week';
      case DiskRetention.month:
        return 'for 1 month';
      case DiskRetention.forever:
        return 'forever';
    }
  }
}

@collection
class Settings extends ChangeNotifier {
  static final Settings _instance = Settings._();

  Settings._();

  factory Settings() => _instance;

  // Entity fields

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

  static ThemeData themeData(ColorScheme colorScheme) => ThemeData(
        colorScheme: colorScheme,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        ),
        useMaterial3: _instance.materialYou,
      );

  static ColorScheme get themeLightColorScheme =>
      ColorScheme.fromSeed(seedColor: _instance.themeColor.toColor());
  static ColorScheme get themeDarkColorScheme => ColorScheme.fromSeed(
      seedColor: _instance.themeColor.toColor(), brightness: Brightness.dark);
  static ThemeMode get themeMode => _instance.themeBrightness.toThemeMode();

  notify() => notifyListeners();
}
