import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

class Player {
  String login;
  String email;
  IconData avatar;

  Player(this.login, this.email, [this.avatar = Icons.person]);

  static List<Player> randomList(int length) {
    return List.generate(length, (i) => random(i));
  }

  static Player random(int index) {
    var login = faker.internet.userName();

    return Player(login, [login, faker.internet.domainName()].join('@'));
  }
}
