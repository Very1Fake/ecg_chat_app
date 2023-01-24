import 'package:ecg_chat_app/models/player.dart';
import 'package:isar/isar.dart';

part 'account.g.dart';

// TODO: Reload account info from API at every startup
@collection
class Account {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uuid;
  @Index(unique: true)
  late String username;
  @Index(unique: true)
  late String email;
  late String token;
  late DateTime expiresAt;
  late DateTime createdAt;

  Player toPlayer() {
    return Player(username);
  }
}
