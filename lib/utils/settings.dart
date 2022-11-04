import 'package:flutter/material.dart';

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
