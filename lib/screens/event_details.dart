import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zeeyou/models/event.dart';
import 'package:zeeyou/screens/set_event.dart';
import 'package:zeeyou/tools/user_manager.dart';
import 'package:zeeyou/widgets/adaptive_alert_dialog.dart';
import 'package:zeeyou/widgets/event_details/add_remove_users.dart';
import 'package:zeeyou/widgets/event_details/event_deails_header.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zeeyou/widgets/event_details/external_links.dart';

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({
    super.key,
    required this.event,
  });

  final Event event;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: event.colors.light,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AdaptiveAlertDialog(
                  title: Text(l10n.waitHere),
                  content: Text(l10n.reallyWantToDelete),
                  actions: [
                    TextButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                      label: Text(l10n.cancel),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.errorContainer,
                          foregroundColor:
                              Theme.of(context).colorScheme.onErrorContainer),
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('events')
                            .doc(event.id)
                            .delete();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.delete_forever_outlined),
                      label: Text(l10n.deleteForever),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.delete_outline),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => SetEventScreen(event: event),
              ));
            },
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: event.colors.light,
          width: double.infinity,
          child: Container(
            width: 20,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(44)),
              color: Theme.of(context).colorScheme.background,
            ),
            child: Column(
              children: [
                EventDetailsHeader(event: event),
                ExternalLinks(event: event),
                // TODO: remove Go to messages button
                // ElevatedButton.icon(
                //   style: ButtonStyle(
                //     backgroundColor:
                //         MaterialStateProperty.all(event.colors.light),
                //     foregroundColor:
                //         MaterialStateProperty.all(event.colors.primary),
                //   ),
                //   onPressed: () {
                //     Navigator.of(context).pop();
                //     openChatScreen(context, event);
                //   },
                //   icon: Icon(MdiIcons.chat),
                //   label: Text(l10n.messages),
                // ),
                const SizedBox(height: 15),
                AddRemoveUsers(event: event),
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('events')
                        .doc(event.id)
                        .update({
                      "user_list": FieldValue.arrayRemove([loggedUserId])
                    });
                    // TODO: should navigate to Home
                    Navigator.of(context).pop();
                  },
                  child: Text(l10n.leaveEvent),
                ),

                //TODO: put these somewhere else
                // FunctionContainer(
                //   colors: event.colors,
                //   icon: MdiIcons.listBoxOutline,
                //   title: 'Liste',
                // ),
                // FunctionContainer(
                //   colors: event.colors,
                //   icon: MdiIcons.chartBoxOutline,
                //   title: 'Sondages',
                //   isDisabled: true,
                // ),
                // FunctionContainer(
                //   colors: event.colors,
                //   icon: MdiIcons.foodForkDrink,
                //   title: 'Repas',
                //   isDisabled: true,
                // ),
                // FunctionContainer(
                //   colors: event.colors,
                //   icon: Icons.euro_outlined,
                //   title: 'Dépenses',
                //   isDisabled: true,
                // ),
                // FunctionContainer(
                //   colors: event.colors,
                //   icon: MdiIcons.car,
                //   title: 'Covoiturage',
                //   isDisabled: true,
                // ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
