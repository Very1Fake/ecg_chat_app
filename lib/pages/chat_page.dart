import 'dart:math';

import 'package:ecg_chat_app/models/message.dart';
import 'package:ecg_chat_app/models/player.dart';
import 'package:ecg_chat_app/widgets/message_bubble.dart';
import 'package:ecg_chat_app/widgets/player_list_item.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

import 'package:ecg_chat_app/models/server.dart';

class ChatPageArgs {
  Server server;

  ChatPageArgs(this.server);
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late Server server;
  late List<Message> messages = List.generate(128, (index) {
    return Message(
        WordPair.random().asPascalCase,
        Random().nextBool()
            ? players[Random().nextInt(players.length - 1)]
            : null);
  });
  List<Player> players = Player.randomList(32);

  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as ChatPageArgs;
    server = args.server;

    Color textColor = Theme.of(context).colorScheme.onPrimaryContainer;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(server.name),
                Visibility(
                    visible: true,
                    child: Text(server.address,
                        style: const TextStyle(
                          fontSize: 11.0,
                          color: Colors.grey,
                        )))
              ]),
          bottom: TabBar(labelColor: textColor, tabs: [
            Tab(
                text: 'Chat',
                icon: Icon(
                  Icons.question_answer,
                  color: textColor,
                )),
            Tab(
                text: 'Player',
                icon: Icon(
                  Icons.people,
                  color: textColor,
                ))
          ]),
        ),
        body: TabBarView(
          children: [
            // FIX: Make better design
            Column(children: [
              Expanded(
                child: ListView.builder(
                    itemCount: messages.length,
                    reverse: true,
                    itemBuilder: (context, index) =>
                        MessageBubble(messages[index])),
              ),
              Container(
                height: 64.0,
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).backgroundColor,
                        hintText: 'Message',
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  IconButton(
                    // FIX: Align width with text input
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0.0, 48.0),
                    ),
                    icon: const Icon(Icons.send),
                    onPressed: () => ScaffoldMessenger.of(context)
                        .showMaterialBanner(MaterialBanner(
                      actions: [
                        Builder(builder: (context) {
                          return IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                  .clearMaterialBanners();
                            },
                            icon: const Icon(Icons.close),
                          );
                        })
                      ],
                      content: const Text(
                          'Message sending will be available soon...'),
                    )),
                  )
                ]),
              ),
            ]),
            ListView.builder(
                itemCount: players.length,
                itemBuilder: (context, index) => PlayerListItem(players[index]))
          ],
        ),
      ),
    );
  }
}
