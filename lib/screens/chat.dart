import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zeeyou/tools/color_shade.dart';
import 'package:zeeyou/widgets/chat_messages.dart';
import 'package:zeeyou/widgets/new_message.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    required this.title,
    required this.chatCollectionRef,
    this.color,
    this.onTitlePress,
    super.key,
  });

  final String title;
  final CollectionReference<Map<String, dynamic>> chatCollectionRef;
  final ColorShade? color;
  final void Function()? onTitlePress;

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
          child: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 20,
            ),
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
