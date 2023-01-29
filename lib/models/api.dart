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
