import 'package:ecg_chat_app/models/message.dart';
import 'package:ecg_chat_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: message.isMine
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.tertiaryContainer,
      ),
      constraints: const BoxConstraints(
        maxWidth: 300.0,
        minWidth: 72.0,
      ),
      child: Stack(
        alignment:
            message.isMine ? Alignment.bottomLeft : Alignment.bottomRight,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!message.isMine)
                Container(
                  margin: const EdgeInsets.only(
                    top: 2.0,
                    left: 12.0,
                    right: 12.0,
                  ),
                  child: Text(
                    message.sender!.username,
                    style: TextStyle(
                      color: theme.colorScheme.tertiary,
                      fontSize: 13.0,
                    ),
                  ),
                ),
              Padding(
                padding: EdgeInsets.only(
                  top: message.isMine ? 12.0 : 0,
                  left: 12.0,
                  right: 12.0,
                  bottom: 14.0,
                ),
                child: Text(
                  message.text,
                  // overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: shiftLightness(
                        theme.brightness,
                        theme.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                        .05),
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(
              right: !message.isMine ? 12.0 : 0.0,
              left: message.isMine ? 12.0 : 0.0,
              bottom: 2.0,
            ),
            child: Text(
              DateFormat('Hm').format(message.timestamp),
              style: TextStyle(
                color: shiftLightness(
                  theme.brightness,
                  message.isMine
                      ? theme.colorScheme.primary
                      : theme.colorScheme.tertiary,
                  .3,
                ),
                fontSize: 10.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
