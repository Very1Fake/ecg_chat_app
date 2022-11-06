import 'package:ecg_chat_app/models/server.dart';
import 'package:ecg_chat_app/pages/chat_page.dart';
import 'package:flutter/material.dart';

class ServerListItem extends StatelessWidget {
  final int index;
  final Server server;
  final Future<bool?> Function(int, Server) showBottomSheet;

  const ServerListItem(this.index, this.server, this.showBottomSheet,
      {super.key});

  @override
  Widget build(BuildContext context) {
    String? description = server.description;

    return ListTile(
      leading: Hero(
        tag: 'server/${server.address}/logo',
        child: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          radius: 32.0,
          child: Icon(
            Icons.broken_image_outlined,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            size: 28.0,
          ),
        ),
      ),
      title: Text(server.serverName),
      subtitle: description != null
          ? Text(description,
              style: TextStyle(color: Theme.of(context).colorScheme.primary))
          : const Text("This server has no description"),
      onTap: () => Navigator.of(context)
          .pushNamed('/chat', arguments: ChatPageArgs(server)),
      onLongPress: () => showBottomSheet(index, server),
    );
  }
}
