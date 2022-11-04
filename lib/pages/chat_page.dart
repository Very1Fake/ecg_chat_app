import 'package:ecg_chat_app/models/message.dart';
import 'package:ecg_chat_app/models/player.dart';
import 'package:ecg_chat_app/utils/theme.dart';
import 'package:ecg_chat_app/widgets/message_bubble.dart';
import 'package:ecg_chat_app/widgets/player_list_item.dart';
import 'package:flutter/material.dart';

import 'package:ecg_chat_app/models/server.dart';
import 'package:flutter/services.dart';

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
  late List<Message> messages = Message.randomList(players);
  List<Player> players = Player.randomList(32);

  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as ChatPageArgs;
    server = args.server;

    Color textColor = AppTheme.useMaterial3
        ? Theme.of(context).colorScheme.onPrimaryContainer
        : Colors.white;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Hero(
                tag: 'server/${server.address}/logo',
                child: CircleAvatar(
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              Column(
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
            ],
          ),
          bottom: TabBar(
              indicatorColor: textColor,
              indicatorPadding: const EdgeInsets.symmetric(horizontal: 2.5),
              indicatorSize:
                  AppTheme.useMaterial3 ? TabBarIndicatorSize.label : null,
              indicatorWeight: AppTheme.useMaterial3 ? 3.0 : 2.0,
              labelColor: textColor,
              tabs: [
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
            Column(children: [
              Expanded(
                child: ListView.builder(
                    itemCount: messages.length,
                    reverse: true,
                    itemBuilder: (context, index) =>
                        MessageBubble(messages[index])),
              ),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 12.0,
                    ),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextField(
                              maxLength: 256,
                              maxLines: 5,
                              minLines: 1,
                              controller: messageController,
                              decoration: InputDecoration(
                                isDense: true,
                                filled: true,
                                fillColor: Theme.of(context).backgroundColor,
                                hintText: 'Message',
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(32.0)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Container(
                            margin: const EdgeInsets.only(bottom: 20.0),
                            child: IconButton(
                              style: IconButton.styleFrom(
                                  fixedSize: const Size(52.0, 52.0),
                                  focusColor: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant
                                      .withOpacity(.12),
                                  highlightColor: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(.12),
                                  side: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  )).copyWith(
                                foregroundColor:
                                    MaterialStateProperty.resolveWith(
                                        (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return Theme.of(context)
                                        .colorScheme
                                        .onSurface;
                                  }
                                  return null;
                                }),
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
                            ),
                          )
                        ]),
                  )
                ],
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
