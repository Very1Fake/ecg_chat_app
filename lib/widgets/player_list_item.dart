import 'package:ecg_chat_app/models/player.dart';
import 'package:ecg_chat_app/widgets/avatar.dart';
import 'package:flutter/material.dart';

typedef Callback = void Function(Player);

class PlayerListItem extends StatelessWidget {
  final Player account;
  final Callback? callback;

  final bool selected;

  final TextStyle? titleStyle;

  const PlayerListItem(this.account,
      {this.selected = false, this.callback, this.titleStyle, super.key});

  @override
  Widget build(BuildContext context) {
    Widget avatar = Container(
      padding: const EdgeInsets.all(4.0),
      child: const Avatar(),
    );

    return ListTile(
      minVerticalPadding: 16.0,
      leading: selected
          ? Stack(
              alignment: Alignment.bottomRight,
              children: [
                avatar,
                CircleAvatar(
                  backgroundColor:
                      Theme.of(context).colorScheme.tertiaryContainer,
                  radius: 9.0,
                  child: Icon(
                    Icons.check,
                    size: 11.0,
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                  ),
                ),
              ],
            )
          : avatar,
      title: Text(account.username, style: titleStyle),
      onTap: callback != null ? () => callback!(account) : null,
    );
  }
}
