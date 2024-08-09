import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeeyou/tools/user_manager.dart';
import 'package:zeeyou/widgets/adaptive_alert_dialog.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> showDeleteAccountDialog({required BuildContext context}) async {
  final l10n = AppLocalizations.of(context)!;

  showDialog(
    context: context,
    builder: (ctx) => AdaptiveAlertDialog(
      title: Text(l10n.waitHere),
      content: Text(l10n.reallyWantToDeleteAccount),
      actions: [
        TextButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          label: Text(l10n.cancel),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              foregroundColor: Theme.of(context).colorScheme.onErrorContainer),
          onPressed: () async {
            SharedPreferences.getInstance()
                .then((prefs) => prefs.remove('currentUserImageUrl'));
            try {
              await FirebaseAuth.instance.currentUser!.delete();
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(loggedUserId)
                  .delete();
            } on FirebaseAuthException catch (e) {
              if (e.code == "requires-recent-login") {
                await _reauthenticateAndDelete(context: context);
              }
            } catch (e) {
              // UserCredential authUser = await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential();
              // await authUser.user!.delete();
            }
            if (context.mounted) {
              Navigator.of(context).pop();
              // Navigator.of(context).pop();
            }
          },
          icon: const Icon(Icons.delete_forever_outlined),
          label: Text(l10n.deleteForever),
        ),
      ],
    ),
  );
}

Future<void> _reauthenticateAndDelete({required BuildContext context}) async {
  final firebaseAuth = FirebaseAuth.instance;
  print("reauth");
  try {
    final providerData = firebaseAuth.currentUser?.providerData.first;

    if (AppleAuthProvider().providerId == providerData!.providerId) {
      await firebaseAuth.currentUser!
          .reauthenticateWithProvider(AppleAuthProvider());
    } else if (GoogleAuthProvider().providerId == providerData.providerId) {
      await firebaseAuth.currentUser!
          .reauthenticateWithProvider(GoogleAuthProvider());
    } else {
      final password = await showDialog<String>(
        context: context,
        builder: (ctx) {
          final passwordController = TextEditingController();
          return AlertDialog(
            title: const Text('Enter your password'),
            content: TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, passwordController.text),
                child: const Text('Confirm'),
              ),
            ],
          );
        },
      );
      await firebaseAuth.currentUser!
          .reauthenticateWithCredential(EmailAuthProvider.credential(
        email: firebaseAuth.currentUser!.email!,
        password: password!,
      ));
    }

    await firebaseAuth.currentUser?.delete();
  } catch (e) {
    print(e);
    // Handle exceptions
  }
}
