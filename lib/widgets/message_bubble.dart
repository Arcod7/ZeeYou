import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:badges/badges.dart' as badges;
import 'package:zeeyou/models/color_shade.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble.first({
    super.key,
    required this.userImage,
    required this.username,
    required this.message,
    required this.messageId,
    required this.isMessageLiked,
    required this.isMe,
    required this.chatCollectionRef,
    this.color,
  }) : isFirstInSequence = true;

  const MessageBubble.next({
    super.key,
    required this.message,
    required this.messageId,
    required this.isMessageLiked,
    required this.isMe,
    required this.chatCollectionRef,
    this.color,
  })  : isFirstInSequence = false,
        userImage = null,
        username = null;

  final bool isFirstInSequence;
  final String? userImage;
  final String? username;
  final String messageId;
  final String message;
  final bool? isMessageLiked;
  final bool isMe;
  final CollectionReference<Map<String, dynamic>> chatCollectionRef;
  final ColorShade? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        if (userImage != null)
          if (!isMe)
            Positioned(
              top: 15,
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  userImage!,
                ),
                backgroundColor: theme.colorScheme.primary.withAlpha(180),
                radius: 23,
              ),
            ),
        GestureDetector(
          // onLongPress: () => chatCollectionRef.doc(messageId).delete(),
          onDoubleTap: () {
            chatCollectionRef.doc(messageId).update({
              'isLiked': !(isMessageLiked ?? false),
            });
          },
          child: Container(
            margin: const EdgeInsets.only(left: 46, right: 0),
            child: Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    if (isFirstInSequence) const SizedBox(height: 18),
                    if (username != null && !isMe)
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 13,
                          right: 13,
                        ),
                        child: Text(
                          username!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    badges.Badge(
                      badgeContent: Icon(
                        MdiIcons.heart,
                        size: 18,
                        color: Colors.red,
                      ),
                      badgeStyle: const badges.BadgeStyle(
                        borderSide: BorderSide(
                          color: Colors.blueGrey,
                          width: 1,
                        ),
                        badgeColor: Colors.white,
                      ),
                      position: badges.BadgePosition.bottomStart(
                          bottom: 0, start: 10),
                      // backgroundColor: Colors.white,
                      // offset: const Offset(20, -5),
                      // alignment: Alignment.bottomLeft,
                      // largeSize: 26,
                      showBadge: isMessageLiked ?? false,
                      child: Container(
                        decoration: BoxDecoration(
                          color: isMe
                              ? color != null
                                  ? color!.veryLight
                                  : theme.colorScheme.inversePrimary
                                      .withAlpha(150)
                              : theme.colorScheme.secondary.withAlpha(200),
                          borderRadius: BorderRadius.only(
                            topLeft: !isMe && isFirstInSequence
                                ? Radius.zero
                                : const Radius.circular(12),
                            topRight: isMe && isFirstInSequence
                                ? Radius.zero
                                : const Radius.circular(12),
                            bottomLeft: const Radius.circular(12),
                            bottomRight: const Radius.circular(12),
                          ),
                        ),
                        constraints: const BoxConstraints(maxWidth: 280),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 14,
                        ),
                        margin: EdgeInsets.only(
                          top: 4,
                          left: 12,
                          right: 12,
                          bottom: (isMessageLiked ?? false) ? 20 : 4,
                        ),
                        child: Text(
                          message,
                          style: TextStyle(
                            height: 1.3,
                            color: isMe
                                ? Colors.black87
                                : theme.colorScheme.onSecondary,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
