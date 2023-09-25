import 'package:flutter/material.dart';
import 'package:zeeyou/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void changeLanguage(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;

  if (l10n.localeName == 'en') {
    App.setLocale(context, const Locale('fr', 'FR'));
  } else if (l10n.localeName == 'fr') {
    App.setLocale(context, const Locale('es', 'ES'));
  } else if (l10n.localeName == 'es') {
    App.setLocale(context, const Locale('en', 'US'));
  } else {
    App.setLocale(context, const Locale('en', 'US'));
  }
}

String getCountryCodeFromLocale(String locale) {
  switch (locale) {
    case 'fr':
      return 'FR';
    case 'en':
      return 'US';
    case 'es':
      return 'ES';
    default:
      return 'US';
  }
}
