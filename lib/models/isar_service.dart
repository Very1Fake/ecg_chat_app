import 'package:ecg_chat_app/models/settings.dart';
import 'package:isar/isar.dart';

import '../utils/theme.dart';

class IsarService {
  late Isar _db;

  static late IsarService _instance;

  static Isar get db => _instance._db;

  static init() async {
    _instance = IsarService();
    _instance._db = await Isar.open(
      [SettingsSchema],
      inspector: true,
    );

    // Load AppTheme
    await db.writeTxn(
      () async {
        Settings? settings = await db.settings.get(0);
        if (settings != null) {
          AppTheme.fromSettings(settings);
        } else {
          db.settings.put(Settings());
        }
      },
    );
  }

  static Stream<Settings?> settingsWatcher() {
    return db.settings.watchObject(0, fireImmediately: true);
  }

  static updateAppThemeSync({
    bool? materialYou,
    ThemeColor? color,
    ThemeBrightness? brightness,
  }) async {
    db.writeTxnSync(() {
      db.settings.putSync((db.settings.getSync(0))!
        ..materialYou = materialYou ?? AppTheme.materialYou
        ..themeColor = color ?? AppTheme.color
        ..themeBrightness = brightness ?? AppTheme.brightness);
    });
  }
}
