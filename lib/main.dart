import 'package:ecg_chat_app/models/account.dart';
import 'package:ecg_chat_app/models/isar_service.dart';
import 'package:ecg_chat_app/models/server.dart';
import 'package:ecg_chat_app/pages/add_account_page.dart';
import 'package:ecg_chat_app/pages/add_server_page.dart';
import 'package:ecg_chat_app/pages/block_list_page.dart';
import 'package:ecg_chat_app/pages/chat_page.dart';
import 'package:ecg_chat_app/pages/main_page.dart';
import 'package:ecg_chat_app/pages/settings_page.dart';
import 'package:ecg_chat_app/utils/theme.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  AppTheme.init();
  AccountManager.init();
  ServerManager.init();
  await IsarService.init();

  runApp(const ChatApp());
}

class ChatApp extends StatefulWidget {
  const ChatApp({super.key});

  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  @override
  Widget build(BuildContext context) {
    IsarService.settingsWatcher().listen((settings) {
      if (settings != null) {
        AppTheme.fromSettings(settings);
        setState(() {});
      }
    });

    return MaterialApp(
      title: 'ECG Chat App',
      themeMode: AppTheme.themeMode,
      theme: AppTheme.themeLight,
      darkTheme: AppTheme.themeDark,
      home: const MainPage(),
      routes: {
        '/chat': (context) => const ChatPage(),
        '/add_server': (context) => const AddServerPage(),
        '/add_account': (context) => const NewAccountPage(),
        '/block_list': (context) => const BlockListPage(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}
