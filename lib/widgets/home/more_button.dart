import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeeyou/env/env.dart';
import 'package:zeeyou/screens/admin_chat.dart';
import 'package:zeeyou/screens/chat.dart';
import 'package:zeeyou/screens/donate.dart';
import 'package:zeeyou/screens/settings.dart';
import 'package:zeeyou/tools/change_language.dart';
import 'package:zeeyou/tools/user_manager.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MoreButtonItem<PopupMenuEntry> extends StatelessWidget {
  const MoreButtonItem({
    super.key,
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 7),
        Text(label),
      ],
    );
  }
}

class MoreButton extends StatelessWidget {
  const MoreButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopupMenuButton(
      itemBuilder: (ctx) => [
        if (loggedUserId == Env.adminUid)
          PopupMenuItem(
            value: 'admin_chat',
            child: MoreButtonItem(
              icon: Icons.chat_outlined,
              label: l10n.adminChat,
            ),
          ),
        PopupMenuItem(
          value: 'chat',
          child: MoreButtonItem(
            icon: Icons.chat_bubble_outline,
            label: l10n.staffChat,
          ),
        ),
        PopupMenuItem(
          value: 'donate',
          child: MoreButtonItem(
            icon: MdiIcons.piggyBankOutline,
            label: l10n.donate,
          ),
        ),
        PopupMenuItem(
          child: MoreButtonItem(
            icon: Icons.language_outlined,
            label: '${l10n.language} (${l10n.localeName})',
          ),
          onTap: () => changeLanguage(context),
        ),
        PopupMenuItem(
          value: 'settings',
          child: MoreButtonItem(
            icon: Icons.settings_outlined,
            label: l10n.settings,
          ),
        ),
        PopupMenuItem(
          child: MoreButtonItem(
            icon: Icons.exit_to_app,
            label: l10n.logOut,
          ),
          onTap: () {
            GoogleSignIn().signOut();
            FirebaseAuth.instance.signOut();
            SharedPreferences.getInstance()
                .then((prefs) => prefs.remove('currentUserImageUrl'));
          },
        ),
      ],
      onSelected: (value) {
        if (value == 'chat') {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => ChatScreen(
                chatCollectionRef: FirebaseFirestore.instance
                    .collection('users')
                    .doc(loggedUserId)
                    .collection('staff_chat'),
                title: l10n.staffChat),
          ));
        }
        if (value == 'admin_chat') {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => const AdminChatScreen()));
        }
        if (value == 'donate') {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (ctx) => const DonateScreen()));
        }
        if (value == 'settings') {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => const SettingsScreen()));
        }
      },
    );
  }
}
