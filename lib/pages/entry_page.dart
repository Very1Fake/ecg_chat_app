import 'package:ecg_chat_app/models/settings.dart';
import 'package:flutter/material.dart';

class EntryPage extends StatelessWidget {
  const EntryPage({super.key});

  // TODO: Make welcome page here
  @override
  Widget build(BuildContext context) {
    Settings().account.load().then((_) {
      if (Settings().account.value != null) {
        Navigator.of(context).popAndPushNamed('/main');
      } else {
        Navigator.of(context).popAndPushNamed('/add_account');
      }
    });

    return const Scaffold(
      body: Text('EntryPage\nWait for account to be loaded'),
    );
  }
}
