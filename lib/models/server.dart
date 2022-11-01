import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:faker/faker.dart';

class Server {
  String address;
  String name;
  String? description;

  Server(this.address, this.name, [this.description]);

  static List<Server> randomList(int length) {
    return List.generate(length, (i) => random(i));
  }

  static Server random(int index) {
    return Server(faker.internet.ipv4Address(), "Server #$index",
        Random().nextBool() ? null : WordPair.random().toString());
  }
}
