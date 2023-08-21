import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zeeyou/models/event.dart';
import 'package:zeeyou/screens/chat.dart';

void openChatScreen(final BuildContext context, final Event event,
    {final void Function()? onTitlePress}) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (ctx) => ChatScreen(
        chatCollectionRef: FirebaseFirestore.instance
            .collection('events')
            .doc(event.id)
            .collection('chat'),
        title: event.title,
        onTitlePress: onTitlePress,
        color: event.colors,
      ),
    ),
  );
}
