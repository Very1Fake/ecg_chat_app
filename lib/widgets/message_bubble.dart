import 'package:ecg_chat_app/models/message.dart';
import 'package:ecg_chat_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    bool fromMe = message.fromMe();

    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Align(
        alignment: fromMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: message.fromMe()
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.tertiary,
          ),
          child: Stack(
            alignment: fromMe ? Alignment.bottomRight : Alignment.bottomLeft,
            children: [
              Container(
                padding: const EdgeInsets.only(
                  top: 12.0,
                  left: 12.0,
                  right: 12.0,
                  bottom: 14.0,
                ),
                child: Text(
                  message.text,
                  style: TextStyle(
                    color: fromMe
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onTertiary,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  right: fromMe ? 12.0 : 0.0,
                  left: !fromMe ? 12.0 : 0.0,
                  bottom: 2.0,
                ),
                child: Text(
                  DateFormat('Hm').format(message.timestamp),
                  style: TextStyle(
                    color: shiftLightness(
                      Theme.of(context).brightness,
                      fromMe
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.tertiary,
                      .3,
                    ),
                    fontSize: 11.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
