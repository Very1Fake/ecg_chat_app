import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:faker/faker.dart';

class Server {
  String address;
  String name;
  String? description;
  bool favorite;

  // TODO: Load favorites from DB
  Server(this.address, this.name, [this.description]) : favorite = false;

  static Server dummy() {
    return Server('127.0.0.1', 'Dummy Server', 'Dummy description');
  }

  static List<Server> randomList(int length) {
    return List.generate(length, (i) => random(i));
  }

  static Server random(int index) {
    return Server(faker.internet.ipv4Address(), "Server #$index",
        Random().nextBool() ? null : WordPair.random().toString());
  }
}
