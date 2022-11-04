import 'package:ecg_chat_app/models/message.dart';
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
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.tertiary,
            ),
            padding: const EdgeInsets.all(12.0),
            child: Text(
              message.text,
              style: TextStyle(
                color: message.fromCurrentUser()
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onTertiary,
              ),
            )),
      ),
    );
  }
}
