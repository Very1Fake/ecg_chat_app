import 'package:ecg_chat_app/models/message.dart';
import 'package:ecg_chat_app/utils/settings.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Align(
        alignment: message.fromCurrentUser()
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: message.fromCurrentUser()
                  ? ThemeColor.caramel.toColor()
                  : Theme.of(context).primaryColorLight,
            ),
            padding: const EdgeInsets.all(12.0),
            child: Text(message.text)),
      ),
    );
  }
}
