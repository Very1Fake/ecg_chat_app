import 'dart:math';

import 'package:ecg_chat_app/models/account.dart';
import 'package:ecg_chat_app/models/server.dart';
import 'package:ecg_chat_app/utils/colors.dart';
import 'package:ecg_chat_app/utils/consts.dart';
import 'package:ecg_chat_app/widgets/player_list_item.dart';
import 'package:ecg_chat_app/widgets/server_list_item.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Account> accountList = Account.randomList(Random().nextInt(4) + 1);
  int currentAccount = 0;
  List<Server> serverList = Server.randomList(128);

  bool accountManagerExpanded = false;
  int selectedTab = 0;

  Widget underConstruction(String text) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.precision_manufacturing_outlined,
            size: 128.0,
            color: Theme.of(context).hintColor,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28.0,
              color: Theme.of(context).hintColor,
            ),
          )
        ],
      ),
    );
  }

  Widget sectionFavorites() {
    int favoritesCount = serverList.where((server) => server.favorite).length;
    return favoritesCount == 0
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.format_list_bulleted,
                  size: 64.0,
                  color: Theme.of(context).hintColor,
                ),
                Text(
                  'Favorite list is empty',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Theme.of(context).hintColor,
                  ),
                )
              ],
            ),
          )
        : ListView.builder(
            itemCount: favoritesCount,
            itemBuilder: (context, index) {
              Server server = serverList
                  .where((server) => server.favorite)
                  .elementAt(index);
              return ServerListItem(
                  serverList.indexOf(server), server, showBottomSheet);
            });
  }

  Future<bool?> showBottomSheet(int index, Server server) {
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
              color: Theme.of(context).hintColor,
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            ),
            margin: const EdgeInsets.symmetric(vertical: 14.0),
          ),
          ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("About server"),
              iconColor: Theme.of(context).colorScheme.primary,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                        'ServerInfoPage will be added in future updates')));
                Navigator.of(context).pop();
              }),
          ListTile(
              leading: const Icon(Icons.push_pin),
              title: const Text("Pin"),
              iconColor: Theme.of(context).colorScheme.primary,
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
              iconColor: Theme.of(context).colorScheme.primary,
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
              iconColor: Theme.of(context).colorScheme.error,
              textColor: Theme.of(context).colorScheme.error,
              onTap: () {
                setState(() {
                  serverList.removeAt(index);
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
    Account account = accountList[currentAccount];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Server List"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0.0),
          children: [
            Container(
              decoration: BoxDecoration(
                color: shiftLightness(Theme.of(context).brightness,
                    Theme.of(context).colorScheme.primaryContainer, 0.0225),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.all(16.0),
                      child: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          radius: 32.0,
                          child: Icon(
                            Icons.person,
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: 42.0,
                          )),
                    ),
                    accountList.length == 1
                        ? ListTile(
                            title: Text(
                              account.login,
                              // style: Theme.of(context).primaryTextTheme.titleSmall,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer),
                            ),
                            subtitle: Text(
                              account.email,
                              style: Theme.of(context).primaryTextTheme.caption,
                            ),
                          )
                        : ExpansionTile(
                            title: Text(
                              account.login,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            subtitle: Text(
                              account.email,
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  ?.copyWith(fontSize: 12.5),
                            ),
                            initiallyExpanded: accountManagerExpanded,
                            childrenPadding:
                                const EdgeInsets.symmetric(vertical: 4.0),
                            onExpansionChanged: (value) => setState(() =>
                                accountManagerExpanded =
                                    !accountManagerExpanded),
                            children: List.generate(
                                accountList.length,
                                (index) => PlayerListItem(
                                      accountList[index].toPlayer(),
                                      selected: index == currentAccount,
                                      callback: index != currentAccount
                                          ? (_) {
                                              setState(
                                                  () => currentAccount = index);
                                              Navigator.of(context).pop();
                                            }
                                          : null,
                                      titleStyle: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    )),
                          ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person_off),
              title: const Text('Blacklist'),
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Blacklist will be implemented soon..."))),
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
              ),
            )
          ],
        ),
      ),
      body: [
        ListView.builder(
          prototypeItem: ServerListItem(0, Server.dummy(), showBottomSheet),
          itemCount: serverList.length,
          itemBuilder: (context, i) =>
              ServerListItem(i, serverList[i], showBottomSheet),
        ),
        sectionFavorites(),
        underConstruction("This section will implemented in future updates"),
      ][selectedTab],
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Adding new server is not implemented yet..."),
            ));
          }),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedTab,
          enableFeedback: true,
          showUnselectedLabels: false,
          onTap: (index) => setState(() {
                selectedTab = index;
              }),
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
