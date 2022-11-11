import 'dart:math';

import 'package:ecg_chat_app/models/server.dart';
import 'package:ecg_chat_app/widgets/bottom_progress_indicator.dart';
import 'package:flutter/material.dart';

class AddServerPage extends StatefulWidget {
  const AddServerPage({super.key});

  @override
  State<AddServerPage> createState() => _AddServerPageState();
}

class _AddServerPageState extends State<AddServerPage> {
  // TODO: Use form
  TextEditingController inputAlias = TextEditingController();
  TextEditingController inputAddress = TextEditingController();
  TextEditingController inputPort = TextEditingController(text: '4567');

  bool loadingServer = false;
  bool invalidAlias = false;
  bool invalidAddress = false;
  bool invalidPort = false;

  @override
  void dispose() {
    inputAlias.dispose();
    inputAddress.dispose();
    inputPort.dispose();
    super.dispose();
  }

  bool validateInputs() {
    bool valid = true;

    // TODO: add symbols validation
    {
      String alias = inputAlias.text.trim();
      if (alias.isNotEmpty && alias.length < 3) {
        invalidAlias = true;
        valid = false;
      } else {
        invalidAlias = false;
      }
    }

    // TODO: add symbols validation
    {
      String address = inputAddress.text.trim();
      if (address.isEmpty || address.length < 3) {
        invalidAddress = true;
        valid = false;
      } else {
        invalidAddress = false;
      }
    }

    {
      int? port = int.tryParse(inputPort.text);

      if (inputPort.text.isEmpty || port == null || port > 65535 || port < 1) {
        invalidPort = true;
        valid = false;
      } else {
        invalidPort = false;
      }
    }

    return valid;
  }

  addServer() {
    if (validateInputs()) {
      loadingServer = true;

      String address =
          "${inputAddress.text.trim()}:${int.parse(inputPort.text)}";
      String? alias = inputAlias.text.trim();
      // Set to null if empty
      alias = alias.isNotEmpty ? alias : null;

      if (ServerManager().list.any((server) => address == server.address)) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Server already exists!'),
            content: const Text(
                'Server with the same address already added to your server list'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'))
            ],
          ),
        );
        loadingServer = false;
      } else {
        // TODO: Proper async request handling
        checkServer(
          address,
          alias,
        ).then((server) {
          if (server == null) {
            showDialog<Server?>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Server not reached!'),
                content: const Text('''We can't reach the server.\n
Do you still want to add it to your server list?'''),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      "Cancel",
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context)
                        .pop(Server(address)..alias = alias),
                    child: const Text("Add"),
                  ),
                ],
              ),
            ).then((server) {
              if (server != null) {
                Navigator.of(context).pop(server);
              } else {
                if (mounted) setState(() => loadingServer = true);
              }
            });
          } else {
            Navigator.of(context).pop(server);
          }
        });
      }
    }

    setState(() {});
  }

  Future<Server?> checkServer(String address, String? alias) async {
    return Future.delayed(const Duration(seconds: 3), () {
      if (Random().nextBool()) {
        return Server.random(0)
          ..address = address
          ..alias = alias;
      } else {
        return null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add server"),
        bottom: loadingServer ? const BottomProgressIndicator() : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: TextField(
                    enabled: !loadingServer,
                    enableSuggestions: true,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.label),
                      border: const OutlineInputBorder(),
                      labelText: 'Alias',
                      hintMaxLines: 1,
                      hintText: 'My Favorite Server',
                      helperMaxLines: 1,
                      helperText: 'Optional',
                      errorMaxLines: 1,
                      errorText: invalidAlias
                          ? 'Alias must contains at least 3 symbols'
                          : null,
                    ),
                    keyboardType: TextInputType.text,
                    maxLength: 32,
                    maxLines: 1,
                    controller: inputAlias,
                  ),
                )
              ],
            ),
            const SizedBox(height: 24.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 6,
                  child: TextField(
                    enabled: !loadingServer,
                    autofocus: true,
                    enableSuggestions: true,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.public),
                      border: const OutlineInputBorder(),
                      labelText: 'Address',
                      hintMaxLines: 1,
                      hintText: 'ecg.server.com',
                      errorMaxLines: 3,
                      errorText: invalidAddress
                          ? 'Invalid server address. Server address can be: IPv4 or domain name'
                          : null,
                    ),
                    keyboardType: TextInputType.url,
                    maxLines: 1,
                    controller: inputAddress,
                  ),
                ),
                const SizedBox(width: 16.0),
                Flexible(
                  flex: 3,
                  child: TextField(
                    enabled: !loadingServer,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Port',
                      hintMaxLines: 1,
                      hintText: '4567',
                      errorMaxLines: 3,
                      errorText: invalidPort
                          ? 'Port must be in range from 1 to 65535'
                          : null,
                    ),
                    keyboardType: TextInputType.number,
                    controller: inputPort,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: loadingServer
          ? null
          : FloatingActionButton(
              onPressed: () => addServer(),
              child: const Icon(Icons.add),
            ),
    );
  }
}
