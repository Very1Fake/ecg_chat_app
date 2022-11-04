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
  bool _useMaterial3;
  ThemeColor _color;
  ThemeBrightness _themeBrightness;

  AppTheme(
      [this._useMaterial3 = true,
      this._color = ThemeColor.caramel,
      this._themeBrightness = ThemeBrightness.system]);

  static late AppTheme _instance;

  static init() {
    _instance = AppTheme();
  }

  static bool get useMaterial3 => _instance._useMaterial3;

  static set useMaterial3(bool use) {
    _instance._useMaterial3 = use;
  }

  static ThemeColor get color => _instance._color;

  static set color(ThemeColor color) {
    _instance._color = color;
  }

  static ThemeBrightness get brightness => _instance._themeBrightness;

  static set brightness(ThemeBrightness mode) {
    _instance._themeBrightness = mode;
  }

  static ThemeData themeData(Brightness brightness) => ThemeData(
        brightness: brightness,
        colorSchemeSeed: AppTheme.color.toColor(),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        ),
        useMaterial3: AppTheme.useMaterial3,
      );
}

class ThemeSwitcher extends InheritedWidget {
  // ignore: library_private_types_in_public_api
  final _ThemeSwitcherWidgetState data;

  const ThemeSwitcher(this.data, child, {super.key}) : super(child: child);

  // ignore: library_private_types_in_public_api
  static _ThemeSwitcherWidgetState of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ThemeSwitcher>()
            as ThemeSwitcher)
        .data;
  }

  @override
  bool updateShouldNotify(ThemeSwitcher oldWidget) {
    return this != oldWidget;
  }
}

class ThemeSwitcherWidget extends StatefulWidget {
  final ThemeData initialTheme;
  final Widget child;

  const ThemeSwitcherWidget(this.initialTheme, this.child, {super.key});

  @override
  State<ThemeSwitcherWidget> createState() => _ThemeSwitcherWidgetState();
}

class _ThemeSwitcherWidgetState extends State<ThemeSwitcherWidget> {
  ThemeData get themeLight => AppTheme.themeData(Brightness.light);
  ThemeData get themeDark => AppTheme.themeData(Brightness.dark);
  ThemeMode get themeMode => AppTheme.brightness.toThemeMode();

  void updateTheme() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitcher(
      this,
      widget.child,
    );
  }
}
