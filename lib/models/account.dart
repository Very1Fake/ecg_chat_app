import 'package:ecg_chat_app/models/player.dart';
import 'package:isar/isar.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

part 'account.g.dart';

@collection
class Account {
  // @ignore
  static final sample = Account(
    '00000000-0000-0000-0000-000000000000',
    'example',
    'example@example.com',
    '',
  );

  Account(this.uuid, this.username, this.email, this.token);

  Account.temp(this.token);

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

  // Sessions

  @ignore
  String? _accessToken;
  @ignore
  DateTime accessExpiry = DateTime.now();

  @ignore
  String? get accessToken => _accessToken;
  set accessToken(String? token) {
    _accessToken = token;
    accessExpiry =
        token != null ? JwtDecoder.getExpirationDate(token) : DateTime.now();
  }
}
