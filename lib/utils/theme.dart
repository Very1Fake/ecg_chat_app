import 'package:ecg_chat_app/models/settings.dart';
import 'package:flutter/material.dart';

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

class AppTheme {
  bool _materialYou;
  ThemeColor _color;
  ThemeBrightness _brightness;

  AppTheme._()
      : _materialYou = true,
        _color = ThemeColor.caramel,
        _brightness = ThemeBrightness.system;

  static late AppTheme _instance;

  static init() {
    _instance = AppTheme._();
  }

  static ThemeData themeData(Brightness brightness) => ThemeData(
        brightness: brightness,
        colorSchemeSeed: AppTheme.color.toColor(),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        ),
        useMaterial3: AppTheme.materialYou,
      );

  static fromSettings(Settings settings) {
    _instance._materialYou = settings.materialYou;
    _instance._color = settings.themeColor;
    _instance._brightness = settings.themeBrightness;
  }

  static ThemeData get themeLight => themeData(Brightness.light);
  static ThemeData get themeDark => themeData(Brightness.dark);
  static ThemeMode get themeMode => brightness.toThemeMode();

  static bool get materialYou => _instance._materialYou;
  static ThemeColor get color => _instance._color;
  static ThemeBrightness get brightness => _instance._brightness;
}
