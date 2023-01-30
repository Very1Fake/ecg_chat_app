import 'package:ecg_chat_app/models/account.dart';
import 'package:ecg_chat_app/models/settings.dart';
import 'package:isar/isar.dart';

import '../utils/api.dart';

class StateManager {
  late Isar _db;

  static late StateManager _instance;

  static Isar get db => _instance._db;

  static init() async {
    _instance = StateManager();
    _instance._db = await Isar.open(
      [SettingsSchema, AccountSchema],
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

  static updateSettings() async {
    await db.writeTxn(() async {
      db.settings.put(Settings());
    }).then((_) => Settings().notify());
  }

  // Accounts related

  static List<Account> get accountList =>
      db.accounts.where().sortByCreatedAt().findAllSync();

  static loadAccount([int? id]) {
    if (id != null) {
      db.writeTxnSync(() {
        Settings().account.value = id > -1
            ? db.accounts.getSync(id)
            : db.accounts.where().sortByCreatedAtDesc().findFirstSync();

        Settings().account.saveSync();
      });
    } else {
      Settings().account.loadSync();
    }

    API.maintainSession();

    Settings().notify();
  }

  static addAccount(Account account) async {
    await db.writeTxn(() async {
      await db.accounts.put(account);

      if (Settings().account.value == null) {
        Settings().account.value = account;
        await Settings().account.save();
      }
    });

    Settings().notify();
  }

  static logOut() {
    db.writeTxnSync(() => db.accounts.deleteSync(Settings().account.value!.id));

    // Try to find another account
    loadAccount(-1);

    Settings().notify();
  }
}
