import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeeyou/firebase_options.dart';
import 'package:zeeyou/screens/auth.dart';
import 'package:zeeyou/screens/home.dart';
import 'package:zeeyou/screens/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:zeeyou/tools/theme.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: App()));
}

class App extends StatefulWidget {
  const App({super.key});

  static void setLocale(BuildContext context, Locale newLocale) async {
    _AppState? state = context.findAncestorStateOfType<_AppState>();

    var prefs = await SharedPreferences.getInstance();
    prefs.setString('languageCode', newLocale.languageCode);
    prefs.setString('countryCode', newLocale.countryCode ?? '');

    state?.setLocale(newLocale);
  }

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool creatingAccount = false;
  Locale _locale = const Locale('en');

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  @override
  void initState() {
    super.initState();
    //TODO: get user locale and set it by default
    // Localizations.localeOf(context);
    _fetchLocale(const Locale('en', 'US')).then((locale) {
      setLocale(locale);
    });
    FlutterNativeSplash.remove();
  }

  Future<Locale> _fetchLocale(Locale defaultLocale) async {
    var prefs = await SharedPreferences.getInstance();

    String languageCode =
        prefs.getString('languageCode') ?? defaultLocale.languageCode;
    String? countryCode =
        prefs.getString('countryCode') ?? defaultLocale.countryCode;

    return Locale(languageCode, countryCode);
  }

  @override
  Widget build(BuildContext context) {
    bool creatingAccount = false;
    return MaterialApp(
      title: 'ZeeYou',
      theme: theme,
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          if (snapshot.hasData) {
            if (creatingAccount) {
              return Scaffold(
                  appBar: AppBar(title: const Text('Creating account')),
                  body: const Center(
                      child: CircularProgressIndicator.adaptive()));
            }
            // return const ThemeTestScreen();
            return const HomeScreen();
          }
          return AuthScreen(
              setCreatingAccount: (value) =>
                  setState(() => creatingAccount = value));
        },
      ),
    );
  }
}
