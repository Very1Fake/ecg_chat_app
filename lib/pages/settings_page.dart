import 'package:ecg_chat_app/models/account.dart';
import 'package:ecg_chat_app/models/isar_service.dart';
import 'package:ecg_chat_app/utils/consts.dart';
import 'package:ecg_chat_app/models/settings.dart';
import 'package:ecg_chat_app/utils/theme.dart';
import 'package:ecg_chat_app/widgets/simple_dialog_tile.dart';
import 'package:ecg_chat_app/widgets/tile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  DiskRetention diskRetention = DiskRetention.oneDay;

  Widget buildSection(String title, List<Widget> children) {
    return Column(children: <Widget>[
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge,
                )),
            const Divider(
              height: 12.0,
              thickness: .75,
            ),
          ],
        ),
      ),
      ...children,
      const SizedBox(height: 16.0)
    ]);
  }

  Widget themeColorIcon(ThemeColor color, [double radius = 18.0]) {
    return TileAvatarColor(
      color.toColor(),
      char: color == ThemeColor.system ? "A" : null,
      radius: radius,
    );
  }

  Widget themeBrightnessIcon(ThemeBrightness brightness,
      [double radius = 18.0]) {
    IconData icon;
    switch (brightness) {
      case ThemeBrightness.light:
        icon = Icons.light_mode;
        break;
      case ThemeBrightness.dark:
        icon = Icons.dark_mode_outlined;
        break;
      default:
        icon = Icons.settings_suggest;
    }

    return TileAvatarIcon(icon, radius: radius);
  }

  Future<ThemeColor?> showColorChooser() {
    return showDialog(
        context: context,
        builder: (context) => SimpleDialog(
            title: const Text("Choose theme color"),
            children: ThemeColor.values
                .map((color) => SimpleDialogTile(
                      title: Text(color.asString()),
                      trailing: themeColorIcon(color, 14.0),
                      onPressed: () => Navigator.of(context).pop(color),
                    ))
                .toList()));
  }

  Future<ThemeBrightness?> showThemeModeChooser() {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text("Choose theme mode"),
        children: ThemeBrightness.values
            .map((mode) => SimpleDialogTile(
                  title: Text(mode.asString()),
                  trailing: themeBrightnessIcon(mode, 14.0),
                  onPressed: () => Navigator.of(context).pop(mode),
                ))
            .toList(),
      ),
    );
  }

  Future<bool?> showConfirmationDialog(String title, String description) {
    return showDialog(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        children: [
          buildSection("Account", [
            ListTile(
              title: const Text("Log Out"),
              onTap: () {
                if (AccountManager().logOut(context)) {
                  Navigator.of(context).pop();
                }
                // setState(() {});
              },
            ),
          ]),
          buildSection("Interface", [
            SwitchListTile(
                title: const Text("Material You Theme"),
                value: AppTheme.materialYou,
                onChanged: (value) =>
                    IsarService.updateAppThemeSync(materialYou: value)
                        .then((_) => setState(() {}))),
            ListTile(
                title: const Text("Theme Color"),
                subtitle: Text(AppTheme.color.asString()),
                trailing: themeColorIcon(AppTheme.color),
                onTap: () => showColorChooser().then((color) =>
                    IsarService.updateAppThemeSync(color: color)
                        .then((_) => setState(() {})))),
            ListTile(
                title: const Text("Theme Mode"),
                subtitle: Text(AppTheme.brightness.asString()),
                trailing: themeBrightnessIcon(AppTheme.brightness),
                onTap: () => showThemeModeChooser().then((mode) =>
                    IsarService.updateAppThemeSync(brightness: mode)
                        .then((_) => setState(() {}))))
          ]),
          buildSection("Data", [
            Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 16.0),
                margin: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                child: Text(
                  "Keep data for",
                  style: Theme.of(context).textTheme.titleSmall,
                )),
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
                  const SnackBar(content: Text("Optimizing local database!"))),
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
                applicationLegalese: applicationLegalese,
              ),
            )
          ]),
        ],
      ),
    );
  }
}
