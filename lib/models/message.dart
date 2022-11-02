import 'player.dart';

class Message {
  String text;
  Player? sender;
  int timestamp;

  Message(this.text, [this.sender])
      : timestamp = DateTime.now().millisecondsSinceEpoch;

  bool fromCurrentUser() {
    return sender == null;
  }
}
