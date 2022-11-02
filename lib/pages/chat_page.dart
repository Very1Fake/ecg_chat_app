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
  late List<Message> messages;
  List<Player> players = Player.randomList(32);

  late TextEditingController messageController;

  @override
  void initState() {
    super.initState();

    var random = Random();

    messages = List.generate(128, (index) {
      return Message(
          WordPair.random().asPascalCase,
          random.nextBool()
              ? players[random.nextInt(players.length - 1)]
              : null);
    });

    messageController = TextEditingController();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as ChatPageArgs;
    server = args.server;

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
                        )))
              ]),
          bottom: const TabBar(tabs: [
            Tab(text: 'Chat', icon: Icon(Icons.question_answer)),
            Tab(text: 'Player', icon: Icon(Icons.people))
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
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Message',
                      ),
                    ),
                  ),
                  const SizedBox(width: 32.0),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.send),
                    label: const Text('Send'),
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
