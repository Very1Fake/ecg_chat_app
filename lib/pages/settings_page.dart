import 'package:ecg_chat_app/utils/consts.dart';
import 'package:ecg_chat_app/utils/settings.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool useMaterialYou = false;
  ThemeColor themeColor = ThemeColor.navy;
  DiskRetention diskRetention = DiskRetention.oneDay;

  Widget buildSection(String title, List<Widget> children) {
    var decorators = <Widget>[
      Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge,
          )),
      const Divider(),
    ];
    decorators.addAll(children);
    decorators.add(const SizedBox(height: 16.0));

    return Column(children: decorators);
  }

  Widget themeColorIcon(ThemeColor color, [double radius = 18.0]) {
    return CircleAvatar(
      backgroundColor: color.toColor(),
      radius: radius,
      child: color == ThemeColor.system
          ? Text("A",
              style: TextStyle(color: Colors.white, fontSize: radius * 1.25))
          : null,
    );
  }

  Future<ThemeColor?> showColorChooser() {
    return showDialog(
        context: context,
        builder: (context) => SimpleDialog(
            title: const Text("Choose theme color"),
            children: ThemeColor.values
                .map((color) => SimpleDialogOption(
                      onPressed: () => Navigator.of(context).pop(color),
                      child: Row(children: [
                        Text(color.asString()),
                        const Spacer(),
                        themeColorIcon(color, 14.0),
                      ]),
                    ))
                .toList()));
  }

  Future<bool?> showConfirmationDialog(String title, String description) {
    return showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(description),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Cancel")),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(
                    "Clear",
                    style: TextStyle(color: Theme.of(context).errorColor),
                  ),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            buildSection("Interface", [
              SwitchListTile(
                  title: const Text("Material You Theme"),
                  value: useMaterialYou,
                  onChanged: (value) => setState(() {
                        useMaterialYou = !useMaterialYou;
                      })),
              ListTile(
                title: const Text("Theme Color"),
                trailing: themeColorIcon(themeColor),
                onTap: () => showColorChooser().then((color) {
                  setState(() {
                    themeColor = color ?? ThemeColor.system;
                  });
                }),
              )
            ]),
            buildSection("Data", [
              Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 16.0),
                  margin: const EdgeInsets.only(bottom: 8.0),
                  child: const Text("Keep data for")),
              Slider(
                  // FIX: Find better design
                  value: diskRetention.index.toDouble(),
                  max: (DiskRetention.values.length - 1).toDouble(),
                  divisions: DiskRetention.values.length - 1,
                  label: diskRetention.asString(),
                  onChanged: (value) => setState(() {
                        diskRetention = DiskRetention.values[value.toInt()];
                      })),
              ListTile(
                title: const Text("Clear Image Cache"),
                subtitle:
                    const Text("Clearing image cache will reduce space usage."),
                onTap: () => showConfirmationDialog("Clear image cache",
                        "Are you sure you want to clear all cached images?")
                    .then((approved) {
                  if (approved ?? false) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Clearing image cache!")));
                  }
                }),
              ),
              ListTile(
                title: const Text("Clear Local Database"),
                subtitle: const Text(
                    "Clearing local database will reduce space usage."),
                onTap: () => showConfirmationDialog("Clear local database",
                        "Are you sure you want to clear cached messages?")
                    .then((approved) {
                  if (approved ?? false) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Clearing local database!")));
                  }
                }),
              ),
              ListTile(
                title: const Text("Optimize Database"),
                subtitle: const Text(
                    "Optimizing a database will reduce its size and slightly increase performance."),
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Optimizing local database!"))),
              ),
            ]),
            buildSection("About", [
              ListTile(
                title: const Text("About"),
                onTap: () => showAboutDialog(
                  context: context,
                  applicationIcon: appIcon,
                  applicationName: appName,
                  applicationVersion: appVersion,
                ),
              )
            ]),
          ],
        ));
  }
}
