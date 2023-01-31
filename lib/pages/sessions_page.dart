import 'package:ecg_chat_app/models/api.dart';
import 'package:flutter/material.dart';

import '../utils/api.dart';
import '../widgets/bottom_progress_indicator.dart';

class SessionsPage extends StatefulWidget {
  const SessionsPage({Key? key}) : super(key: key);

  @override
  State<SessionsPage> createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  UserSessions? userSessions;
  bool loading = false;
  bool loadingSessions = false;

  @override
  void initState() {
    super.initState();
    loadSessions();
  }

  loadSessions() async {
    loadingSessions = true;
    Future(() async => await API.userSessions()).then((sessions) {
      userSessions = sessions;
      setState(() => mounted ? loadingSessions = false : null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: !loading ? () => Navigator.of(context).pop() : null,
              )
            : null,
        title: const Text('Sessions'),
        bottom: loading ? const BottomProgressIndicator() : null,
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          FilledButton.tonal(
              onPressed: !loading
                  ? () {
                      setState(() => loading = true);
                      Future(() async {
                        return await API.tokenRevokeAll();
                      }).then((success) {
                        if (mounted) {
                          if (success) {
                            loadSessions();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Failed to terminate all sessions')));
                          }
                          setState(() => loading = false);
                        }
                      });
                    }
                  : null,
              style: ButtonStyle(
                  padding:
                      MaterialStateProperty.all(const EdgeInsets.all(16.0)),
                  backgroundColor: MaterialStateProperty.all(
                      theme.colorScheme.errorContainer)),
              child: Text(
                'Terminate all sessions',
                style: TextStyle(
                  color: theme.colorScheme.onErrorContainer,
                ),
              )),
          const SizedBox(height: 8.0),
          Card(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(16, 16, 0, 12),
                  child: Text(
                    "Active Sessions",
                    style: theme.textTheme.titleSmall!
                        .copyWith(color: theme.colorScheme.onPrimaryContainer),
                  ),
                ),
                if (loadingSessions || !loadingSessions && userSessions == null)
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: !loadingSessions && userSessions == null
                          ? Icon(
                              Icons.error,
                              color: theme.colorScheme.error,
                              size: 48,
                            )
                          : const CircularProgressIndicator()),
                if (!loadingSessions)
                  userSessions?.web?.asTile() ?? const SizedBox(),
                if (!loadingSessions)
                  userSessions?.game?.asTile() ?? const SizedBox(),
                if (!loadingSessions)
                  userSessions?.mobile?.asTile() ?? const SizedBox(),
                const SizedBox(height: 12),
              ],
            ),
          )
        ],
      ),
    );
  }
}
