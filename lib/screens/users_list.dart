import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:zeeyou/tools/user_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserTile extends StatelessWidget {
  const UserTile({
    super.key,
    required this.loadedUser,
    required this.isChecked,
    required this.onSelectedUser,
  });

  final Map<String, dynamic> loadedUser;
  final bool isChecked;
  final void Function() onSelectedUser;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          loadedUser['image_url'],
        ),
      ),
      title: Text('${loadedUser['username']}'),
      trailing: Icon(isChecked
          ? Icons.check_box_outlined
          : Icons.check_box_outline_blank_outlined),
      onTap: () {
        onSelectedUser();
      },
    );
  }
}

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({
    super.key,
    required this.title,
    this.filterIn,
    this.filterNotIn,
  });

  final String title;
  final List<String>? filterIn;
  final List<String>? filterNotIn;

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  late final Set<String> selectedUserIds;

  @override
  void initState() {
    setState(() {
      selectedUserIds = {};
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (selectedUserIds.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.save_outlined),
              onPressed: () {
                Navigator.of(context).pop(selectedUserIds);
              },
            )
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .orderBy('username')
              .snapshots(),
          builder: (context, userSnapshots) {
            if (!userSnapshots.hasData || userSnapshots.data!.docs.isEmpty) {
              return Center(
                child: Text(l10n.noUsersForNow),
              );
            }

            if (userSnapshots.hasError) {
              return Center(child: Text(l10n.errorPlaceHolder));
            }

            final loadedUsers = userSnapshots.data!.docs;

            return Padding(
              padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
              child: SearchableList(
                initialList: loadedUsers,
                builder: (a, userId, b) {
                  final user = loadedUsers[userId];
                  final loadedUser = user.data();

                  if (user.id == loggedUserId ||
                      (widget.filterIn != null &&
                          !widget.filterIn!.contains(user.id)) ||
                      (widget.filterNotIn != null &&
                          widget.filterNotIn!.contains(user.id))) {
                    return const SizedBox();
                  }

                  return UserTile(
                    loadedUser: loadedUser,
                    isChecked: selectedUserIds.contains(user.id),
                    onSelectedUser: () {
                      if (selectedUserIds.contains(user.id)) {
                        setState(() => selectedUserIds.remove(user.id));
                      } else {
                        setState(() => selectedUserIds.add(user.id));
                      }
                    },
                  );
                },
                filter: (value) => loadedUsers
                    .where(
                      (element) => element
                          .data()['username']
                          .toLowerCase()
                          .contains(value),
                    )
                    .toList(),
                emptyWidget: Center(child: Text(l10n.nobodyFound)),
                inputDecoration: InputDecoration(
                  labelText: l10n.searchFriend,
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
