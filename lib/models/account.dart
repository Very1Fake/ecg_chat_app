import 'package:ecg_chat_app/models/player.dart';
import 'package:faker/faker.dart';

class Account {
  String login;
  String email;

  Account(this.login, this.email);

  static List<Account> randomList(int length) {
    return List.generate(length, (i) => random());
  }

  static Account random() {
    String login = faker.internet.userName();

    return Account(login, [login, faker.internet.domainName()].join('@'));
  }

  Player toPlayer() {
    return Player(login);
  }
}
