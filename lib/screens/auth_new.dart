import 'package:flutter_login/flutter_login.dart';
import 'package:zeeyou/widgets/decoration_circle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreenNew extends StatefulWidget {
  const AuthScreenNew({super.key});

  @override
  State<AuthScreenNew> createState() => _AuthScreenNewState();
}

class _AuthScreenNewState extends State<AuthScreenNew>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Stack(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        children: [
          Positioned(
            top: 185,
            left: -100,
            child: ScaleTransition(
                scale: _animation, child: const DecorationCircle()),
          ),
          Positioned(
            bottom: 70,
            right: -50,
            child: ScaleTransition(
                scale: _animation, child: const DecorationCircle()),
          ),
          FlutterLogin(
            onLogin: (hello) async => "Bonjour",
            onRecoverPassword: (hello) async => "Bonjour",
            theme: LoginTheme(
              pageColorLight: Colors.transparent,
              pageColorDark: Colors.transparent,
              primaryColor: Theme.of(context).colorScheme.inversePrimary,
            ),
            initialAuthMode: AuthMode.signup,
          ),
        ],
      ),
    );
  }
}
