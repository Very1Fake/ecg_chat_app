import 'package:ecg_chat_app/models/account.dart';
import 'package:ecg_chat_app/models/settings.dart';
import 'package:faker/faker.dart';
import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

class IsarService {
  late Isar _db;

  static late IsarService _instance;

  static Isar get db => _instance._db;

  static init() async {
    _instance = IsarService();
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

  // Accounts related

  static List<Account> get accountList =>
      db.accounts.where().sortByCreatedAt().findAllSync();

  static switchAccount(Account account) {
    db.writeTxnSync(() {
      db.settings.putSync(Settings()..account.value = account);
    });
  }

  static login(String username, String _) async {
    var account = Account()
      ..uuid = const Uuid().v4()
      ..username = username
      ..email = [username, faker.internet.domainName()].join('@')
      ..token = "<some-refresh-token>"
      ..expiresAt = DateTime.now().add(const Duration(days: 30))
      ..createdAt = DateTime.now();
    Settings().account.value = account;

    await db.writeTxn(() async {
      await db.accounts.put(account);
      await Settings().account.save();
    });

    Settings().notify();
  }

  static register(String username, String email, String password) async {
    var account = Account()
      ..uuid = const Uuid().v4()
      ..username = username
      ..email = email
      ..token = "<some-refresh-token>"
      ..expiresAt = DateTime.now().add(const Duration(days: 30))
      ..createdAt = DateTime.now();
    Settings().account.value = account;

    await db.writeTxn(() async {
      await db.accounts.put(account);
      await Settings().account.save();
    });

    Settings().notify();
  }

  static logOut() {
    db.writeTxnSync(() {
      db.accounts.deleteSync(Settings().account.value!.id);

      // Try to find another account
      db.settings.putSync(Settings()
        ..account.value =
            db.accounts.where().sortByCreatedAtDesc().findFirstSync());
    });

    Settings().notify();
  }
}
