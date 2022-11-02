import 'package:flutter/material.dart';

// TODO: Proper use at `Settings`
enum ThemeColor {
  system,
  navy,
  mint,
  lavender,
  caramel,
  forest,
  wine;

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

// TODO: Proper use at `Settings`
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

class Settings {
  static bool _initialized = false;

  static late Settings singleton;

  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
  }
}
