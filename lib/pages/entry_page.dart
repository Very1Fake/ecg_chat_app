import 'package:ecg_chat_app/models/settings.dart';
import 'package:ecg_chat_app/models/state_manager.dart';
import 'package:flutter/material.dart';

class EntryPage extends StatefulWidget {
  const EntryPage({super.key});

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  @override
  void initState() {
    super.initState();

    Future(() => StateManager.loadAccount()).then((_) {
      if (Settings().account.value != null) {
        Navigator.of(context).popAndPushNamed('/main');
      } else {
        Navigator.of(context).popAndPushNamed('/add_account');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
