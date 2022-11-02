import 'package:ecg_chat_app/models/player.dart';
import 'package:ecg_chat_app/utils/settings.dart';
import 'package:flutter/material.dart';

class PlayerListItem extends StatelessWidget {
  final Player account;

  const PlayerListItem(this.account, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 16.0,
      leading: CircleAvatar(
        backgroundColor:
            ThemeColor.caramel.toColor(), // FIX: Use color from theme
        child: const Icon(Icons.person),
      ),
      title: Text(account.login),
    );
  }
}
