import 'package:zeeyou/widgets/chat_messages.dart';
import 'package:zeeyou/widgets/new_message.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    required this.title,
    required this.chatType,
    required this.chatId,
    super.key,
  });

  final String title;
  final String chatType;
  final String chatId;

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatMessages(
              chatId: widget.chatId,
              chatType: widget.chatType,
            ),
          ),
          NewMessage(
            chatId: widget.chatId,
            chatType: widget.chatType,
          ),
        ],
      ),
    );
  }
}
