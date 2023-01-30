import 'package:ecg_chat_app/models/state_manager.dart';
import 'package:ecg_chat_app/models/server.dart';
import 'package:ecg_chat_app/models/settings.dart';
import 'package:ecg_chat_app/pages/add_account_page.dart';
import 'package:ecg_chat_app/pages/add_server_page.dart';
import 'package:ecg_chat_app/pages/block_list_page.dart';
import 'package:ecg_chat_app/pages/chat_page.dart';
import 'package:ecg_chat_app/pages/entry_page.dart';
import 'package:ecg_chat_app/pages/main_page.dart';
import 'package:ecg_chat_app/pages/settings_page.dart';
import 'package:ecg_chat_app/utils/api.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await StateManager.init();

  API.init();
  ServerManager.init();

  runApp(const ChatApp());
}

class ChatApp extends StatefulWidget {
  const ChatApp({super.key});

  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  @override
  void initState() {
    super.initState();
    Settings().addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ECG Chat App',
      themeMode: Settings.themeMode,
      theme: Settings.themeLight,
      darkTheme: Settings.themeDark,
      routes: {
        '/': (context) => const EntryPage(),
        '/main': (context) => const MainPage(),
        '/chat': (context) => const ChatPage(),
        '/add_server': (context) => const AddServerPage(),
        '/add_account': (context) => const NewAccountPage(),
        '/block_list': (context) => const BlockListPage(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}
