import 'package:ecg_chat_app/models/settings.dart';
import 'package:isar/isar.dart';


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
        if (settings == null) {
          db.settings.put(Settings());
        }
      },
    );
  }

  // Settings related

  static updateAppThemeSync({
    bool? materialYou,
    ThemeColor? color,
    ThemeBrightness? brightness,
  }) {
    if (materialYou != null) {
      Settings().materialYou = materialYou;
    }

    if (color != null) {
      Settings().themeColor = color;
    }

    if (brightness != null) {
      Settings().themeBrightness = brightness;
    }

    db.writeTxnSync(() {
      db.settings.putSync(Settings());
    });

    Settings().notify();
  }
}
