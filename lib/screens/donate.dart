import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:zeeyou/l10n/app_localizations.dart';

class DonateScreen extends StatelessWidget {
  const DonateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    int donateAmount = 5;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.donate)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
                onPressed: () {
                  launchUrlString(
                    'https://paypal.me/antoineesman/$donateAmount',
                    mode: LaunchMode.externalApplication,
                  );
                  donateAmount *= 5;
                },
                icon: const Icon(Icons.paypal_outlined),
                label: const Text('Paypal')),
            const SizedBox(height: 80),
            ElevatedButton.icon(
                onPressed: () {
                  launchUrlString(
                    'https://www.buymeacoffee.com/antoineesman',
                    mode: LaunchMode.externalApplication,
                  );
                },
                icon: Icon(MdiIcons.bee),
                label: const Text('BuyMeABee')),
          ],
        ),
      ),
    );
  }
}
