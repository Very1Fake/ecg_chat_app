import 'package:ecg_chat_app/models/server.dart';
import 'package:flutter/material.dart';

class ServerListItem extends StatelessWidget {
  const ServerListItem(this.server, {super.key});

  final Server server;

  @override
  Widget build(BuildContext context) {
    String? description = server.description;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.green[500],
        child: const Icon(Icons.dns_rounded, color: Colors.white,),
      ),
      title: Text(server.name),
      subtitle: description != null ? Text(description) : null,
      minVerticalPadding: 16.0,
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Chat View is not implemented yet..."))),
    );
  }
}
