import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:badges/badges.dart' as badges;

class MessageBubble extends StatefulWidget {
  const MessageBubble.first({
    super.key,
    required this.userImage,
    required this.username,
    required this.messageId,
    required this.message,
    required this.isMe,
    required this.chatCollectionRef,
  }) : isFirstInSequence = true;

  const MessageBubble.next({
    super.key,
    required this.message,
    required this.messageId,
    required this.isMe,
    required this.chatCollectionRef,
  })  : isFirstInSequence = false,
        userImage = null,
        username = null;

  final bool isFirstInSequence;
  final String? userImage;
  final String? username;
  final String messageId;
  final String message;
  final bool isMe;
  final CollectionReference<Map<String, dynamic>> chatCollectionRef;

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  bool _isReactionVisible = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        if (widget.userImage != null)
          Positioned(
            top: 15,
            // Align user image to the right, if the message is from me.
            right: widget.isMe ? 0 : null,
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                widget.userImage!,
              ),
              backgroundColor: theme.colorScheme.primary.withAlpha(180),
              radius: 23,
            ),
          ),
        GestureDetector(
          onDoubleTap: () {
            setState(() {
              _isReactionVisible = !_isReactionVisible;
            });
            // chatCollectionRef.doc(messageId).delete();
          },
          child: Container(
            // Add some margin to the edges of the messages, to allow space for the
            // user's image.
            margin: const EdgeInsets.symmetric(horizontal: 46),
            child: Row(
              // The side of the chat screen the message should show at.
              mainAxisAlignment:
                  widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: widget.isMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    // First messages in the sequence provide a visual buffer at
                    // the top.
                    if (widget.isFirstInSequence) const SizedBox(height: 18),
                    if (widget.username != null)
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 13,
                          right: 13,
                        ),
                        child: Text(
                          widget.username!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                    // The "speech" box surrounding the message.
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
                      position: badges.BadgePosition.bottomStart(bottom: 0, start: 10),
                      // backgroundColor: Colors.white,
                      // offset: const Offset(20, -5),
                      // alignment: Alignment.bottomLeft,
                      // largeSize: 26,
                      showBadge: _isReactionVisible,
                      child: Container(
                        decoration: BoxDecoration(
                          color: widget.isMe
                              ? Colors.grey[300]
                              : theme.colorScheme.secondary.withAlpha(200),
                          // Only show the message bubble's "speaking edge" if first in
                          // the chain.
                          // Whether the "speaking edge" is on the left or right depends
                          // on whether or not the message bubble is the current user.
                          borderRadius: BorderRadius.only(
                            topLeft: !widget.isMe && widget.isFirstInSequence
                                ? Radius.zero
                                : const Radius.circular(12),
                            topRight: widget.isMe && widget.isFirstInSequence
                                ? Radius.zero
                                : const Radius.circular(12),
                            bottomLeft: const Radius.circular(12),
                            bottomRight: const Radius.circular(12),
                          ),
                        ),
                        // Set some reasonable constraints on the width of the
                        // message bubble so it can adjust to the amount of text
                        // it should show.
                        constraints: const BoxConstraints(maxWidth: 200),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 14,
                        ),
                        // Margin around the bubble.
                        margin: EdgeInsets.only(
                          top: 4,
                          left: 12,
                          right: 12,
                          bottom: _isReactionVisible ? 20 : 4,
                        ),
                        child: Text(
                          widget.message,
                          style: TextStyle(
                            // Add a little line spacing to make the text look nicer
                            // when multilined.
                            height: 1.3,
                            color: widget.isMe
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
