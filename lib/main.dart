import 'package:ecg_chat_app/models/server.dart';
import 'package:ecg_chat_app/pages/new_server_page.dart';
import 'package:ecg_chat_app/pages/chat_page.dart';
import 'package:ecg_chat_app/pages/main_page.dart';
import 'package:ecg_chat_app/pages/settings_page.dart';
import 'package:ecg_chat_app/utils/theme.dart';
import 'package:flutter/material.dart';

void main() {
  AppTheme.init();
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
        '/new_server': (context) => const NewServerPage(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}
