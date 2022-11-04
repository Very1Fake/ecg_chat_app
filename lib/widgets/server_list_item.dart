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
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        radius: 32.0,
        child: const Icon(
          Icons.broken_image_outlined,
          color: Colors.white,
          size: 28.0,
        ),
      ),
      title: Text(server.name),
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
