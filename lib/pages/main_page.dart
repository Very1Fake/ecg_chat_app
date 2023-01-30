import 'package:ecg_chat_app/models/account.dart';
import 'package:ecg_chat_app/models/state_manager.dart';
import 'package:ecg_chat_app/models/server.dart';
import 'package:ecg_chat_app/models/settings.dart';
import 'package:ecg_chat_app/utils/consts.dart';
import 'package:ecg_chat_app/utils/pair.dart';
import 'package:ecg_chat_app/widgets/avatar.dart';
import 'package:ecg_chat_app/widgets/centered_icon_message.dart';
import 'package:ecg_chat_app/widgets/drag_handler.dart';
import 'package:ecg_chat_app/widgets/server_list_item.dart';
import 'package:ecg_chat_app/widgets/simple_dialog_tile.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentAccount = -1;
  List<Pair<int, String>> accountList = [];

  bool accountManagerExpanded = false;
  bool needToScrollToBottom = false;
  int section = 0;

  final ScrollController scrollController =
      ScrollController(keepScrollOffset: true);

  @override
  void initState() {
    super.initState();
    Settings().addListener(onSettingsChanged);
    onSettingsChanged();
  }

  @override
  void dispose() {
    Settings().removeListener(onSettingsChanged);
    super.dispose();
  }

  onSettingsChanged() {
    if (Settings().account.value != null) {
      setState(() => currentAccount = Settings().account.value!.id);
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false);
    }
  }

  changeSection(int newSection) {
    // Scroll to top if current section
    if (newSection == section) {
      if (!scrollController.hasClients) return;

      scrollController.animateTo(
        scrollController.position.minScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    } else {
      setState(() => section = newSection);
    }
  }

  addServer([replace = false]) {
    (replace
            ? Navigator.of(context).popAndPushNamed('/add_server')
            : Navigator.of(context).pushNamed('/add_server'))
        .then((result) {
      var server = result as Server?;
      if (server != null) {
        // TODO: Scroll to newly added server
        setState(() => ServerManager().list.add(server));
      }
    });
  }

  accountSwitcher() {
    Navigator.of(context).pop();
    showDialog(
        context: context,
        builder: (context) =>
            SimpleDialog(title: const Text("Accounts"), children: [
              ...StateManager.accountList
                  .map((acc) => SimpleDialogTile(
                      leading: const Avatar(tertiary: true),
                      title: Text(acc.username),
                      trailing: acc.id == currentAccount
                          ? const Avatar(
                              icon: Icons.check,
                              container: true,
                              transparent: true,
                            )
                          : null,
                      onPressed: () => Navigator.of(context)
                          .pop(acc.id != currentAccount ? acc.id : null)))
                  .toList(),
              SimpleDialogTile(
                leading: const Avatar(
                    icon: Icons.add, container: true, transparent: true),
                title: const Text("Add new account"),
                onPressed: () =>
                    Navigator.of(context).pushNamed('/add_account'),
              ),
              const SizedBox(height: 8),
            ])).then((account) {
      if (account != null) {
        StateManager.loadAccount(account);
      }
    });
  }

  Widget sectionFavorites() {
    int favoritesCount =
        ServerManager().list.where((server) => server.favorite).length;
    return favoritesCount == 0
        ? const CenteredIconMessage(
            Icons.format_list_bulleted, 'Favorite list is empty')
        : ListView.builder(
            key: const PageStorageKey("MainPageScroll>Favorites"),
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: favoritesCount,
            itemBuilder: (context, index) {
              Server server = ServerManager()
                  .list
                  .where((server) => server.favorite)
                  .elementAt(index);
              return ServerListItem(ServerManager().list.indexOf(server),
                  server, showBottomSheet);
            },
          );
  }

  Future<bool?> showBottomSheet(int index, Server server) {
    var theme = Theme.of(context);

    return showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        children: [
          const DragHandle(),
          ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("About server"),
              iconColor: theme.colorScheme.primary,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                        'ServerInfoPage will be added in future updates')));
                Navigator.of(context).pop();
              }),
          ListTile(
              leading: const Icon(Icons.push_pin),
              title: const Text("Pin"),
              iconColor: theme.colorScheme.primary,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                        'Pinning server to top will be available in future updates')));
                Navigator.of(context).pop();
              }),
          ListTile(
              leading: server.favorite
                  ? const Icon(Icons.favorite_border)
                  : const Icon(Icons.favorite),
              title: server.favorite
                  ? const Text("Remove from favorites")
                  : const Text("Add to favorites"),
              iconColor: theme.colorScheme.primary,
              onTap: () {
                // Change favorite status and request update
                setState(() {
                  server.favorite = !server.favorite;
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(server.favorite
                        ? '"${server.name} removed from favorites"'
                        : '"${server.name}" added to favorites')));
                Navigator.of(context).pop();
              }),
          ListTile(
              leading: const Icon(Icons.delete),
              title: const Text("Remove server"),
              iconColor: theme.colorScheme.error,
              textColor: theme.colorScheme.error,
              onTap: () {
                setState(() {
                  ServerManager().list.removeAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('"${server.name}" removed')));
                Navigator.of(context).pop();
              })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var account = Settings().account.value ?? Account.sample;
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Server List"),
      ),
      drawerEdgeDragWidth: MediaQuery.of(context).size.width,
      drawer: NavigationDrawer(
        selectedIndex: null,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              addServer(true);
              break;
            case 1:
              Navigator.of(context).pushNamed('/block_list');
              break;
            case 2:
              Navigator.of(context).pushNamed('/settings');
              break;
            case 3:
              showAboutDialog(
                context: context,
                applicationIcon: appIcon,
                applicationName: appName,
                applicationVersion: appVersion,
                applicationLegalese: applicationLegalese,
              );
              break;
          }
        },
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 16),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 28),
            leading: const Avatar(
              tertiary: true,
              radius: 20.0,
            ),
            title: Text(account.username),
            subtitle: Text(account.email),
            onTap: () => accountSwitcher(),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 8),
            child: Divider(),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.add),
            label: Text('New server'),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.person_off),
            label: Text('Block list'),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.settings),
            label: Text('Settings'),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 8),
            child: Divider(),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.info),
            label: Text('About app'),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: theme.colorScheme.onSurfaceVariant,
        backgroundColor: theme.colorScheme.surfaceVariant,
        onRefresh: () async =>
            Future.delayed(const Duration(seconds: 1)).then((value) {
          if (mounted) {
            for (final server in section == 0
                ? ServerManager().list
                : section == 1
                    ? ServerManager().list.where((server) => server.favorite)
                    : <Server>[]) {
              server.description = Server.random(0).description;
            }
            setState(() {});
          }
        }),
        child: [
          ListView.builder(
            key: const PageStorageKey("MainPageScroll>All"),
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            prototypeItem: ServerListItem(0, Server.dummy(), showBottomSheet),
            itemCount: ServerManager().list.length,
            itemBuilder: (context, i) =>
                ServerListItem(i, ServerManager().list[i], showBottomSheet),
          ),
          sectionFavorites(),
          const CenteredIconMessage(
            Icons.precision_manufacturing_outlined,
            "This section will implemented in future updates",
          ),
        ][section],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => addServer(),
      ),
      bottomNavigationBar: NavigationBar(
          selectedIndex: section,
          onDestinationSelected: (index) => changeSection(index),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dns_outlined),
              selectedIcon: Icon(Icons.dns),
              label: "Servers",
              tooltip: "List of game servers",
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_outline),
              selectedIcon: Icon(Icons.favorite),
              label: "Favorites",
              tooltip: "List of favorite servers",
            ),
            NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore),
              label: "Discover",
              tooltip: "Hub social (WIP)",
            ),
          ]),
    );
  }
}
