import 'package:ecg_chat_app/widgets/session_tile.dart';
import 'package:flutter/material.dart';

class UserData {
  final String uuid;
  final String username;
  final String email;
  final UserStatus status;
  final DateTime createdAt;

  UserData.fromMap(Map<String, dynamic> map)
      : uuid = map['uuid'],
        username = map['username'],
        email = map['email'],
        status = UserStatus.values[map['status']],
        createdAt =
            DateTime.fromMillisecondsSinceEpoch(map['created_at'] * 1000);
}

class UserInfo {
  final String uuid;
  final String username;
  final UserStatus status;

  UserInfo.fromMap(Map<String, dynamic> map)
      : uuid = map['uuid'],
        username = map['username'],
        status = UserStatus.values[map['status']];
}

enum UserStatus {
  active,
  inactive,
  banned,
}

class TokenPair {
  final String refresh;
  final String access;

  TokenPair(this.refresh, this.access);
}

class UserSessions {
  UserSession? web;
  UserSession? game;
  UserSession? mobile;

  UserSessions.fromMap(Map<String, dynamic> map)
      : web = map.containsKey('web') ? UserSession.fromMap(map['web']) : null,
        game =
            map.containsKey('game') ? UserSession.fromMap(map['game']) : null,
        mobile = map.containsKey('mobile')
            ? UserSession.fromMap(map['mobile'])
            : null;
}

class UserSession {
  String uuid;
  ClientType clientType;
  DateTime expiresAt;
  DateTime updatedAt;

  UserSession.fromMap(Map<String, dynamic> map)
      : uuid = map['uuid'],
        clientType = ClientType.values[map['ct']],
        expiresAt =
            DateTime.fromMillisecondsSinceEpoch(map['expires_at'] * 1000),
        updatedAt =
            DateTime.fromMillisecondsSinceEpoch(map['updated_at'] * 1000);

  Widget asTile() {
    return SessionTile.fromUserSession(this);
  }
}

enum ClientType {
  web(0),
  game(1),
  mobile(2);

  const ClientType(this.value);
  final int value;

  String asString() {
    switch (this) {
      case ClientType.web:
        return "Web Session";
      case ClientType.game:
        return "Game Session";
      case ClientType.mobile:
        return "Mobile Session";
    }
  }

  IconData asIcon() {
    switch (this) {
      case ClientType.web:
        return Icons.web;
      case ClientType.game:
        return Icons.sports_esports;
      case ClientType.mobile:
        return Icons.smartphone;
    }
  }
}
