import 'dart:math';

import 'package:ecg_chat_app/models/player.dart';
import 'package:ecg_chat_app/widgets/centered_icon_message.dart';
import 'package:ecg_chat_app/widgets/player_list_item.dart';
import 'package:flutter/material.dart';

class BlockListPage extends StatefulWidget {
  const BlockListPage({super.key});

  @override
  State<BlockListPage> createState() => _BlockListPageState();
}

enum PopupMenu {
  removeMessages,
  unblockAll,
}

class _BlockListPageState extends State<BlockListPage> {
  List<Player> players = Player.randomList(Random().nextInt(16));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Block list'),
        actions: [
          PopupMenuButton<PopupMenu>(
            // Callback that sets the selected popup menu item.
            onSelected: (PopupMenu item) {
              switch (item) {
                case PopupMenu.removeMessages:
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          'This feature will be available in future updates!')));
                  break;
                case PopupMenu.unblockAll:
                  setState(() => players.clear());
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<PopupMenu>(
                value: PopupMenu.removeMessages,
                child: Text('Remove messages'),
              ),
              const PopupMenuItem<PopupMenu>(
                value: PopupMenu.unblockAll,
                child: Text('Unblock all'),
              ),
            ],
          ),
        ],
      ),
      body: players.isNotEmpty
          ? ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) => PlayerListItem(players[index]))
          : const CenteredIconMessage(Icons.person_off, 'Block list is empty'),
    );
  }
}
