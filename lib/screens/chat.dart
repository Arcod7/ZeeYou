import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zeeyou/models/event.dart';
import 'package:zeeyou/models/color_shade.dart';
import 'package:zeeyou/widgets/chat_messages.dart';
import 'package:zeeyou/widgets/new_message.dart';
import 'package:flutter/material.dart';

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
        heroTag: event.id + event.title,
      ),
    ),
  );
}

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {super.key,
      required this.title,
      required this.chatCollectionRef,
      this.color,
      this.onTitlePress,
      this.heroTag});

  final String title;
  final CollectionReference<Map<String, dynamic>> chatCollectionRef;
  final ColorShade? color;
  final void Function()? onTitlePress;
  final String? heroTag;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // void setupPushNotifications() async {
  //   final fcm = FirebaseMessaging.instance;

  // await fcm.requestPermission();

  // fcm.subscribeToTopic('chat_${widget.chatId}');

  // final token = await fcm.getToken();
  // print(token); // could send this to backend
  // }

  @override
  void initState() {
    super.initState();

    // setupPushNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final Color? color = widget.color != null ? widget.color!.primary : null;
    return Scaffold(
      appBar: AppBar(
        title: TextButton(
          onPressed: widget.onTitlePress ?? () {},
          style: TextButton.styleFrom(foregroundColor: color),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Hero(
                  tag: widget.heroTag ?? 0,
                  child: Text(widget.title,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: color))),
              const SizedBox(width: 5),
              Icon(Icons.info_outline, color: color),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatMessages(
              chatCollectionRef: widget.chatCollectionRef,
            ),
          ),
          NewMessage(
            chatCollectionRef: widget.chatCollectionRef,
          ),
        ],
      ),
    );
  }
}
