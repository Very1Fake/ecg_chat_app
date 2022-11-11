import 'package:ecg_chat_app/models/account.dart';
import 'package:ecg_chat_app/models/server.dart';
import 'package:ecg_chat_app/pages/add_account_page.dart';
import 'package:ecg_chat_app/pages/add_server_page.dart';
import 'package:ecg_chat_app/pages/chat_page.dart';
import 'package:ecg_chat_app/pages/main_page.dart';
import 'package:ecg_chat_app/pages/settings_page.dart';
import 'package:ecg_chat_app/utils/theme.dart';
import 'package:flutter/material.dart';

// TODO: Add autofill service

void main() {
  AppTheme.init();
  AccountManager.init();
  ServerManager.init();

  runApp(ThemeSwitcherWidget(ThemeData.dark(), const ChatApp()));
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ECG Chat App',
      themeMode: ThemeSwitcher.of(context).themeMode,
      theme: ThemeSwitcher.of(context).themeLight,
      darkTheme: ThemeSwitcher.of(context).themeDark,
      home: const MainPage(),
      routes: {
        '/chat': (context) => const ChatPage(),
        '/add_server': (context) => const AddServerPage(),
        '/add_account': (context) => const NewAccountPage(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}
