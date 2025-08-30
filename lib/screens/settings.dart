import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:zeeyou/l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _value = false;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Section 1'),
            tiles: [
              SettingsTile.navigation(
                  title: const Text('yo'), value: const Text('polo')),
              SettingsTile(
                title: const Text('Language'),
                value: const Text('English'),
                leading: const Icon(Icons.language),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile.switchTile(
                initialValue: _value,
                title: const Text('Use System Theme'),
                leading: const Icon(Icons.phone_android),
                onToggle: (value) => setState(() => _value = value),
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Section 2'),
            tiles: [
              SettingsTile(
                title: const Text('Security'),
                // description: const Text('Fingerprint'),
                leading: const Icon(Icons.lock),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile.switchTile(
                initialValue: false,
                title: const Text('Use fingerprint'),
                leading: const Icon(Icons.fingerprint),
                onToggle: (value) {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
