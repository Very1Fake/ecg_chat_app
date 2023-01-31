import 'package:ecg_chat_app/models/api.dart';
import 'package:flutter/material.dart';

class SessionTile extends StatelessWidget {
  final ClientType clientType;
  final DateTime expiresAt;
  final DateTime updatedAt;

  const SessionTile(this.clientType, this.expiresAt, this.updatedAt,
      {super.key});

  SessionTile.fromUserSession(UserSession session, {super.key})
      : clientType = session.clientType,
        expiresAt = session.expiresAt,
        updatedAt = session.updatedAt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      iconColor: theme.colorScheme.onSecondaryContainer,
      leading: SizedBox(
          height: double.infinity,
          child: Icon(clientType.asIcon(), size: 38.0)),
      title: Text(
        clientType.asString(),
        style: TextStyle(color: theme.colorScheme.onSecondaryContainer),
      ),
      subtitle: Text(
        'Last used at $updatedAt\nExpires at $expiresAt',
        style: theme.textTheme.bodySmall!.copyWith(
            color: theme.colorScheme.onSecondaryContainer.withOpacity(.7)),
      ),
      isThreeLine: true,
    );
  }
}
