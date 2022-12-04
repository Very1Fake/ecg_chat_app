import 'dart:math';

import 'package:ecg_chat_app/models/account.dart';
import 'package:ecg_chat_app/models/server.dart';
import 'package:ecg_chat_app/utils/colors.dart';
import 'package:ecg_chat_app/utils/consts.dart';
import 'package:ecg_chat_app/widgets/avatar.dart';
import 'package:ecg_chat_app/widgets/centered_icon_message.dart';
import 'package:ecg_chat_app/widgets/player_list_item.dart';
import 'package:ecg_chat_app/widgets/server_list_item.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool accountManagerExpanded = false;
  bool needToScrollToBottom = false;
  int section = 0;

  final ScrollController scrollController =
      ScrollController(keepScrollOffset: true);

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
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.0))),
      context: context,
      builder: (context) => Column(
        children: [
          Container(
            width: 64.0,
            height: 4.0,
            decoration: BoxDecoration(
              color: theme.hintColor,
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            ),
            margin: const EdgeInsets.symmetric(vertical: 14.0),
          ),
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
    var accountList = AccountManager().accountList;
    var account = AccountManager().account;

    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Server List"),
      ),
      drawerEdgeDragWidth: MediaQuery.of(context).size.width,
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0.0),
          children: [
            Container(
              decoration: BoxDecoration(
                color: shiftLightness(theme.brightness,
                    theme.colorScheme.primaryContainer, 0.0225),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.all(16.0),
                      child: CircleAvatar(
                        backgroundColor: theme.colorScheme.primary,
                        radius: 32.0,
                        child: Icon(
                          Icons.person,
                          color: theme.colorScheme.onPrimary,
                          size: 42.0,
                        ),
                      ),
                    ),
                    ExpansionTile(
                      title: Text(
                        account.username,
                        style: theme.textTheme.titleSmall,
                      ),
                      subtitle: Text(
                        account.email,
                        style:
                            theme.textTheme.caption?.copyWith(fontSize: 12.5),
                      ),
                      initiallyExpanded: accountManagerExpanded,
                      childrenPadding:
                          const EdgeInsets.symmetric(vertical: 4.0),
                      onExpansionChanged: (value) => setState(() =>
                          accountManagerExpanded = !accountManagerExpanded),
                      children: List.generate(
                          accountList.length,
                          (index) => PlayerListItem(
                                accountList[index].toPlayer(),
                                selected: index == AccountManager().selected,
                                callback: index != AccountManager().selected
                                    ? (_) {
                                        setState(() =>
                                            AccountManager().selected = index);
                                        Navigator.of(context).pop();
                                      }
                                    : null,
                                titleStyle: theme.textTheme.titleSmall,
                              ))
                        ..add(ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(4.0),
                            child: const Avatar(
                              icon: Icons.add,
                              container: true,
                              transparent: true,
                            ),
                          ),
                          title: const Text("Add Account"),
                          onTap: () =>
                              Navigator.of(context).pushNamed('/add_account'),
                        )),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('New Server'),
              onTap: () => addServer(true),
            ),
            ListTile(
              leading: const Icon(Icons.person_off),
              title: const Text('Block List'),
              onTap: () => Navigator.of(context).pushNamed('/block_list'),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => Navigator.of(context).pushNamed('/settings'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text("About app"),
              onTap: () => showAboutDialog(
                context: context,
                applicationIcon: appIcon,
                applicationName: appName,
                applicationVersion: appVersion,
                applicationLegalese: applicationLegalese,
              ),
            )
          ],
        ),
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
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: section,
          enableFeedback: true,
          showUnselectedLabels: false,
          onTap: (index) => changeSection(index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dns), label: "Servers"),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: "Favorites"),
            BottomNavigationBarItem(
                icon: Icon(Icons.explore), label: "Explore"),
          ]),
    );
  }
}
