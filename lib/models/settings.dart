// TODO: Proper use at `Settings`
import 'package:ecg_chat_app/utils/theme.dart';
import 'package:isar/isar.dart';

part 'settings.g.dart';

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
class Settings {
  Id id = 0;

  // Theme related

  bool materialYou = true;

  @enumerated
  ThemeColor themeColor = ThemeColor.caramel;

  @enumerated
  ThemeBrightness themeBrightness = ThemeBrightness.system;

  // Data related

  @enumerated
  DiskRetention diskRetention = DiskRetention.week;
}
