import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

class Player {
  String username;
  IconData avatar;

  Player(this.username, [this.avatar = Icons.person]);

  static List<Player> randomList(int length) {
    return List.generate(length, (i) => random());
  }

  static Player random() {
    var login = faker.internet.userName();

    return Player(login);
  }
}
