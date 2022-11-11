import 'dart:math';

import 'package:ecg_chat_app/models/player.dart';
import 'package:faker/faker.dart';
import 'package:flutter/widgets.dart';

class AccountManager {
  List<Account> _list;
  int _selected;

  AccountManager._()
      : _list = Account.randomList(Random().nextInt(2) + 1),
        _selected = 0;

  static late AccountManager _instance;

  factory AccountManager() => _instance;

  static bool _isInitialized = false;

  static init() {
    if (!_isInitialized) {
      _isInitialized = true;
      _instance = AccountManager._();
    }
  }

  bool logOut(BuildContext context) {
    _list.removeAt(_selected);
    if (_selected > 0) _selected--;

    if (_list.isEmpty) {
      _selected = 0;
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/add_account', (_) => false);
      return false;
    }

    return true;
  }

  _add(Account account) {
    _list.add(account);
  }

  Account add(String username, String _) {
    var account = Account(username, faker.internet.email());
    _add(account);

    return account;
  }

  Account create(String username, String email, String _) {
    var account = Account(username, email);
    _add(account);

    return account;
  }

  bool get authorized => _list.isNotEmpty;
  List<Account> get accountList => _list;
  Account get account => _list[_selected];
  int get selected => _selected;

  set selected(int id) {
    if (_list.length > id) {
      _selected = id;
    }
  }
}

class Account {
  String username;
  String email;

  Account(this.username, this.email);

  static List<Account> randomList(int length) {
    return List.generate(length, (i) => random());
  }

  static Account random() {
    String login = faker.internet.userName();

    return Account(login, [login, faker.internet.domainName()].join('@'));
  }

  Player toPlayer() {
    return Player(username);
  }
}
