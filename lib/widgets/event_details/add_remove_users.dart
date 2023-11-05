import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zeeyou/models/event.dart';
import 'package:zeeyou/screens/users_list.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddRemoveUsers extends StatelessWidget {
  const AddRemoveUsers({
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () async {
            userList = await getUserList();
            if (context.mounted) {
              final Set<String>? userIds = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => UsersListScreen(
                    title: l10n.addUsersToEvent,
                    filterNotIn: userList,
                  ),
                ),
              );
              if (userIds == null || userIds.isEmpty) {
                return;
              }
              await FirebaseFirestore.instance
                  .collection('events')
                  .doc(event.id)
                  .update(
                      {"user_list": FieldValue.arrayUnion(userIds.toList())});
              showSnackBarUserAdded(userIds, l10n.added);
            }
          },
          child: Text(l10n.addUsers),
        ),
        ElevatedButton(
          onPressed: () async {
            userList = await getUserList();
            if (context.mounted) {
              final Set<String>? userIds = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) {
                    return UsersListScreen(
                      title: l10n.removeUsersToEvent,
                      filterIn: userList,
                    );
                  },
                ),
              );
              if (userIds == null || userIds.isEmpty) {
                return;
              }
              await FirebaseFirestore.instance
                  .collection('events')
                  .doc(event.id)
                  .update(
                      {"user_list": FieldValue.arrayRemove(userIds.toList())});
              showSnackBarUserAdded(userIds, l10n.removed);
            }
          },
          child: Text(l10n.removeUsers),
        ),
      ],
    );
  }
}
