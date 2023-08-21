import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:zeeyou/tools/user_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserTile extends StatefulWidget {
  const UserTile({
    super.key,
    required this.loadedUser,
    required this.userId,
    required this.selectedUserIds,
  });

  final Map<String, dynamic> loadedUser;
  final String userId;
  final Set<String> selectedUserIds;

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          widget.loadedUser['image_url'],
        ),
      ),
      title: Text('${widget.loadedUser['username']}'),
      trailing: Icon(widget.selectedUserIds.contains(widget.userId)
          ? Icons.check_box_outlined
          : Icons.check_box_outline_blank_outlined),
      onTap: () {
        if (widget.selectedUserIds.contains(widget.userId)) {
          setState(() {
            widget.selectedUserIds.remove(widget.userId);
          });
        } else {
          setState(() {
            widget.selectedUserIds.add(widget.userId);
          });
        }
      },
    );
  }
}

class UsersListScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final Set<String> selectedUserIds = {};

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
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
            if (userSnapshots.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

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
                builder: (userId) {
                  final user = loadedUsers[userId];
                  final loadedUser = user.data();

                  if (user.id == loggedUserId ||
                      (filterIn != null && !filterIn!.contains(user.id)) ||
                      (filterNotIn != null && filterNotIn!.contains(user.id))) {
                    return const SizedBox();
                  }

                  return UserTile(
                    loadedUser: loadedUser,
                    userId: user.id,
                    selectedUserIds: selectedUserIds,
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
                    borderSide: const BorderSide(
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
