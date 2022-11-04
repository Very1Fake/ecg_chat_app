import 'package:ecg_chat_app/pages/add_server_page.dart';
import 'package:ecg_chat_app/pages/chat_page.dart';
import 'package:ecg_chat_app/pages/main_page.dart';
import 'package:ecg_chat_app/pages/settings_page.dart';
import 'package:ecg_chat_app/utils/settings.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ECG Chat App',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: ThemeColor.caramel.toColor(),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        ),
        useMaterial3: true,
      ),
      home: const MainPage(),
      routes: {
        '/chat': (context) => const ChatPage(),
        '/add_server': (context) => const AddServerPage(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}
