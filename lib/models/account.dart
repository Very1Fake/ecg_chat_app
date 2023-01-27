import 'package:ecg_chat_app/models/player.dart';
import 'package:isar/isar.dart';

part 'account.g.dart';

// TODO: Reload account info from API at every startup
@collection
class Account {
  @ignore
  static final sample = Account()
    ..uuid = '00000000-0000-0000-0000-000000000000'
    ..username = 'sample'
    ..email = 'sample@mail.com'
    ..token = '';

  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uuid;
  @Index(unique: true)
  late String username;
  @Index(unique: true)
  late String email;
  late String token;
  DateTime expiresAt = DateTime.now()..add(const Duration(days: 30));
  DateTime createdAt = DateTime.now();

  Player toPlayer() {
    return Player(username);
  }
}
