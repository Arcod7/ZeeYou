import 'package:flutter/material.dart';
import 'package:zeeyou/l10n/app_localizations.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('ZeeYou'),
      ),
      body: Center(
        child: Text(l10n.loading),
      ),
    );
  }
}
