import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:faker/faker.dart';

class ServerManager {
  List<Server> list;

  ServerManager._() : list = Server.randomList(16);

  static late ServerManager _instance;

  factory ServerManager() => _instance;

  static bool _isInitialized = false;

  static init() {
    if (!_isInitialized) {
      _isInitialized = true;
      _instance = ServerManager._();
    }
  }
}

class Server {
  String address;
  String? alias;
  String? name;
  String? description;
  bool favorite;

  // TODO: Load favorites from DB
  Server(this.address, {this.name, this.description, this.alias})
      : favorite = false;

  String get serverName =>
      (alias != null ? "$alias ($name)" : name) ??
      (alias != null ? "$alias <$address>" : "<$address>");

  static Server dummy() {
    return Server('127.0.0.1',
        name: 'Dummy Server', description: 'Dummy description');
  }

  static List<Server> randomList(int length) {
    return List.generate(length, (i) => random(i));
  }

  static Server random(int index) {
    return Server(faker.internet.ipv4Address(),
        name: "Server #$index",
        description: Random().nextBool() ? null : WordPair.random().toString());
  }
}
