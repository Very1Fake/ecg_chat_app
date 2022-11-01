import 'package:ecg_chat_app/models/server.dart';
import 'package:ecg_chat_app/widgets/server_list_item.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Server> serverList = Server.randomList(128);

  int selectedTab = 0;

  Widget underConstruction(String text) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction,
            size: 128.0,
            color: Colors.grey[500],
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 28.0, color: Colors.grey[500]),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Server List"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Text(
                "Drawer header",
                style: Theme.of(context).textTheme.headline5,
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
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Settings will be implemented soon..."))),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text("About app"),
              onTap: () => showAboutDialog(
                context: context,
                applicationIcon: const Icon(Icons.message),
                applicationName: "ECG Chat App",
                applicationVersion: "0.0.1",
              ),
            )
          ],
        ),
      ),
      body: [
        ListView.builder(
          itemCount: serverList.length,
          itemBuilder: (context, i) => ServerListItem(serverList[i]),
        ),
        underConstruction("'Favorites' section will be implemented soon..."),
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
