import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:zeeyou/screens/chat.dart';

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
    int donateAmount = 5;

    return PopupMenuButton(
      itemBuilder: (ctx) => [
        // TextButton.icon(icon: Icon(Icons.exit_to_app), label: Text('log out')),
        const PopupMenuItem(
          value: 'chat',
          child: MoreButtonItem(
            icon: Icons.chat_bubble_outline,
            label: 'Staff chat',
          ),
        ),
        PopupMenuItem(
          child: MoreButtonItem(
            icon: MdiIcons.piggyBankOutline,
            label: 'Donate',
          ),
          onTap: () async {
            launchUrlString(
              'https://paypal.me/antoineesman/$donateAmount',
              mode: LaunchMode.externalApplication,
            );
            donateAmount *= 5;
          },
        ),
        PopupMenuItem(
          child: const MoreButtonItem(
            icon: Icons.exit_to_app,
            label: 'Log out',
          ),
          onTap: () {
            FirebaseAuth.instance.signOut();
          },
        ),
        PopupMenuItem(
          child: const MoreButtonItem(
            icon: Icons.settings_outlined,
            label: 'Settings',
          ),
          onTap: () {},
        ),
      ],
      onSelected: (value) {
        if (value == 'chat') {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => const ChatScreen(
                chatType: 'staff_chat',
                chatId: 'staff',
                title: 'Discute avec nous !'),
          ));
        }
      },
    );
  }
}
