import 'package:ecg_chat_app/models/server.dart';
import 'package:ecg_chat_app/pages/chat_page.dart';
import 'package:flutter/material.dart';

class ServerListItem extends StatelessWidget {
  final Server server;

  const ServerListItem(this.server, {super.key});

  @override
  Widget build(BuildContext context) {
    String? description = server.description;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.green[500],
        child: const Icon(
          Icons.broken_image_outlined,
          color: Colors.white,
        ),
      ),
      title: Text(server.name),
      subtitle: description != null ? Text(description) : null,
      minVerticalPadding: 16.0,
      onTap: () => Navigator.of(context)
          .pushNamed('/chat', arguments: ChatPageArgs(server)),
    );
  }
}
