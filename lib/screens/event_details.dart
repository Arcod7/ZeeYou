import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:zeeyou/models/event.dart';
import 'package:zeeyou/screens/chat.dart';
import 'package:zeeyou/screens/set_event.dart';
import 'package:zeeyou/screens/users_list.dart';
import 'package:zeeyou/widgets/adaptive_alert_dialog.dart';
import 'package:zeeyou/widgets/event_details/event_deails_header.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zeeyou/widgets/event_details/external_links.dart';
import 'package:zeeyou/widgets/event_details/function_container.dart';

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({
    super.key,
    required this.event,
  });

  final Event event;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    List<String>? userList;
    Future<List<String>?> getUserList() async {
      final eventData = await FirebaseFirestore.instance
          .collection('events')
          .doc(event.id)
          .get();
      return List.castFrom(eventData.data()!['user_list'] as List);
    }

    Future<String> getUserNamesFromSet(Set<String> userIds) async {
      final collectionRef = await FirebaseFirestore.instance
          .collection('users')
          .where(FieldPath.documentId, whereIn: userIds)
          .get();
      return collectionRef.docs
          .map((user) => user.data()['username'])
          .toList()
          .join(', ');

      // final usernamesList = await Future.wait(
      //     userIds.map((userId) async => await getUsername(userId)));
      // return usernamesList.join(', ');
    }

    void showSnackBarUserAdded(Set<String> userIds, String lastWord) async {
      final usernames = await getUserNamesFromSet(userIds);
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$usernames $lastWord')));
      }
    }

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
                ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(event.colors.light),
                    foregroundColor:
                        MaterialStateProperty.all(event.colors.primary),
                  ),
                  onPressed: () => openChatScreen(context, event),
                  icon: Icon(MdiIcons.chat),
                  label: Text(l10n.messages),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        userList = await getUserList();
                        if (context.mounted) {
                          final userIds = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => UsersListScreen(
                                title: l10n.addUsersToEvent,
                                filterNotIn: userList,
                              ),
                            ),
                          );
                          await FirebaseFirestore.instance
                              .collection('events')
                              .doc(event.id)
                              .update({
                            "user_list": FieldValue.arrayUnion(userIds.toList())
                          });
                          showSnackBarUserAdded(userIds, l10n.added);
                        }
                      },
                      child: Text(l10n.addUsers),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        userList = await getUserList();
                        if (context.mounted) {
                          final userIds = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) {
                                return UsersListScreen(
                                  title: l10n.removeUsersToEvent,
                                  filterIn: userList,
                                );
                              },
                            ),
                          );
                          await FirebaseFirestore.instance
                              .collection('events')
                              .doc(event.id)
                              .update({
                            "user_list":
                                FieldValue.arrayRemove(userIds.toList())
                          });
                          showSnackBarUserAdded(userIds, l10n.removed);
                        }
                      },
                      child: Text(l10n.removeUsers),
                    ),
                  ],
                ),
                FunctionContainer(
                  colors: event.colors,
                  icon: MdiIcons.listBoxOutline,
                  title: 'Liste',
                ),
                FunctionContainer(
                  colors: event.colors,
                  icon: MdiIcons.chartBoxOutline,
                  title: 'Sondages',
                  isDisabled: true,
                ),
                FunctionContainer(
                  colors: event.colors,
                  icon: MdiIcons.foodForkDrink,
                  title: 'Repas',
                  isDisabled: true,
                ),
                FunctionContainer(
                  colors: event.colors,
                  icon: Icons.euro_outlined,
                  title: 'Dépenses',
                  isDisabled: true,
                ),
                FunctionContainer(
                  colors: event.colors,
                  icon: MdiIcons.car,
                  title: 'Covoiturage',
                  isDisabled: true,
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
