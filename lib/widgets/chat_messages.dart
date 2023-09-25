import 'package:zeeyou/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({
    super.key,
    required this.chatCollectionRef,
  });

  final CollectionReference<Map<String, dynamic>> chatCollectionRef;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authenticatedUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
      stream:
          chatCollectionRef.orderBy('createdAt', descending: true).snapshots(),
      builder: (ctx, chatSnapshots) {
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
          return Center(
            child: Text(l10n.noMessagesForNow),
          );
        }

        if (chatSnapshots.hasError) {
          return Center(
            child: Text(l10n.errorPlaceHolder + chatSnapshots.error.toString()),
          );
        }

        final loadedMessages = chatSnapshots.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.only(
            bottom: 40,
            left: 13,
            right: 13,
          ),
          reverse: true,
          itemCount: loadedMessages.length,
          itemBuilder: (ctx, index) {
            final messageId = loadedMessages[index].id;
            final chatMessage = loadedMessages[index].data();
            final nextChatMessage = index + 1 < loadedMessages.length
                ? loadedMessages[index + 1].data()
                : null;

            final currentMessageUserId = chatMessage['userId'];
            final nextMessageUserId =
                nextChatMessage != null ? nextChatMessage['userId'] : null;
            final nextUserIsSame = nextMessageUserId == currentMessageUserId;

            if (nextUserIsSame) {
              return MessageBubble.next(
                chatCollectionRef: chatCollectionRef,
                message: chatMessage['text'],
                messageId: messageId,
                isMessageLiked: chatMessage['isLiked'],
                isMe: authenticatedUser.uid == currentMessageUserId,
              );
            } else {
              return MessageBubble.first(
                chatCollectionRef: chatCollectionRef,
                userImage: chatMessage['userImage'],
                username: chatMessage['username'],
                message: chatMessage['text'],
                messageId: messageId,
                isMessageLiked: chatMessage['isLiked'],
                isMe: authenticatedUser.uid == currentMessageUserId,
              );
            }
          },
        );
      },
    );
  }
}
