import 'dart:math';

import 'package:english_words/english_words.dart';

import 'player.dart';

class Message {
  String text;
  Player? sender;
  DateTime timestamp;

  Message(this.text, [this.sender, timestamp])
      : timestamp = timestamp ?? DateTime.now();

  bool get isMine {
    return sender == null;
  }

  static List<Message> randomList(List<Player> players, [length = 128]) {
    Random random = Random();
    DateTime lastDate = DateTime.now();

    return List.generate(length, (index) {
      DateTime date = lastDate;
      lastDate = lastDate.subtract(Duration(seconds: random.nextInt(2048)));

      return Message(
          List.generate(
                  random.nextInt(5) + 1, (_) => WordPair.random().asString)
              .join(' '),
          random.nextBool()
              ? players[random.nextInt(players.length - 1)]
              : null,
          date);
    });
  }
}
