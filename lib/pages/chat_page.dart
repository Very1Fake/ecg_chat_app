import 'package:ecg_chat_app/models/message.dart';
import 'package:ecg_chat_app/models/player.dart';
import 'package:ecg_chat_app/utils/theme.dart';
import 'package:ecg_chat_app/widgets/message_bubble.dart';
import 'package:ecg_chat_app/widgets/avatar.dart';
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

  showBannerMessage(String message) {
    ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
      actions: [
        Builder(builder: (context) {
          return IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).clearMaterialBanners();
            },
            icon: const Icon(Icons.close),
          );
        })
      ],
      content: Text(message),
    ));
  }

  Future<void> showBottomSheet(Player player) {
    var theme = Theme.of(context);

    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.0))),
      context: context,
      builder: (context) => Column(
        children: [
          Container(
            width: 64.0,
            height: 4.0,
            decoration: BoxDecoration(
              color: theme.hintColor,
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            ),
            margin: const EdgeInsets.symmetric(vertical: 14.0),
          ),
          ListTile(
              leading: const Icon(Icons.person),
              title: Text("@${player.username}"),
              iconColor: theme.colorScheme.primary,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                        'ServerInfoPage will be added in future updates')));
                Navigator.of(context).pop();
              }),
          const Divider(thickness: .5),
          ListTile(
              leading: const Icon(Icons.alternate_email),
              title: const Text('Mention'),
              iconColor: theme.colorScheme.primary,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                        'Mention feature will be available future updates')));
                Navigator.of(context).pop();
              }),
          ListTile(
              leading: const Icon(Icons.person_off),
              title: const Text("Block"),
              iconColor: theme.colorScheme.error,
              textColor: theme.colorScheme.error,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content:
                        Text('Adding player to the block list will be available'
                            'in future update')));
                Navigator.of(context).pop();
              })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    server =
        (ModalRoute.of(context)!.settings.arguments as ChatPageArgs).server;

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
                child: const Avatar(
                  icon: Icons.broken_image_outlined,
                  container: true,
                ),
              ),
              const SizedBox(width: 16.0),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(server.serverName), // FIX: Text overflow
                    Visibility(
                        visible: server.name != null,
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
                    text: 'Players',
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
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    itemCount: messages.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      Message message = messages[index];

                      return GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) => SimpleDialog(
                            children: [
                              SimpleDialogOption(
                                child: const Text('Copy'),
                                onPressed: () async {
                                  Clipboard.setData(
                                    ClipboardData(text: message.text),
                                  );
                                  Navigator.of(context).pop();
                                },
                              ),
                              SimpleDialogOption(
                                child: const Text('Delete'),
                                onPressed: () {
                                  showBannerMessage(
                                      'Delete message feature will added soon...');
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: message.isMine
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (!message.isMine)
                                const Avatar()
                              else
                                const Flexible(flex: 1, child: SizedBox()),
                              if (!message.isMine) const SizedBox(width: 8.0),
                              Flexible(flex: 3, child: MessageBubble(message)),
                              if (!message.isMine)
                                const Flexible(flex: 1, child: SizedBox()),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
              Padding(
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
                        maxLines: 3,
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
                      margin: const EdgeInsets.only(bottom: 23.0),
                      child: IconButton(
                        style: IconButton.styleFrom(
                            fixedSize: const Size(50.0, 50.0),
                            focusColor: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant
                                .withOpacity(.12),
                            highlightColor: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(.12),
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.outline,
                            )).copyWith(
                          foregroundColor: MaterialStateProperty.resolveWith(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Theme.of(context).colorScheme.onSurface;
                            }
                            return null;
                          }),
                        ),
                        icon: const Icon(Icons.send),
                        onPressed: () => showBannerMessage(
                            'Message sending will be available soon...'),
                      ),
                    )
                  ],
                ),
              )
            ]),
            ListView.builder(
                itemCount: players.length,
                itemBuilder: (context, index) => PlayerListItem(
                      players[index],
                      longCallback: showBottomSheet,
                    ))
          ],
        ),
      ),
    );
  }
}
