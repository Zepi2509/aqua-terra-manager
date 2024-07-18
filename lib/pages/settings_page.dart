import 'package:aqua_terra_manager/constants.dart';
import 'package:aqua_terra_manager/locator.dart';
import 'package:aqua_terra_manager/notifier/theme_change_notifier.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _themeChangeNotifier = locator<ThemeChangeNotifier>();

  final themeModeSegments = List<ButtonSegment>.of({
    const ButtonSegment(value: ThemeMode.light, label: Text("Hell")),
    const ButtonSegment(value: ThemeMode.dark, label: Text("Dunkel")),
    const ButtonSegment(value: ThemeMode.system, label: Text("System")),
  });
  var selectedThemeMode = <dynamic>{
    ThemeMode.system,
  };

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _themeChangeNotifier,
      builder: (context, themeMode, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Einstellungen'),
          ),
          body: ListView(
            children: [
              const ListTile(
                title: Text('Design'),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: SizeConstants.s500),
                child: SegmentedButton(
                  segments: themeModeSegments,
                  selected: selectedThemeMode,
                  onSelectionChanged: (newSelection) {
                    setState(() {
                      selectedThemeMode = newSelection;
                      _themeChangeNotifier.updateTheme(newSelection.first);
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
