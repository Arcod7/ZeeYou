import 'package:zeeyou/models/event.dart';
import 'package:zeeyou/widgets/chat_messages.dart';
import 'package:zeeyou/widgets/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.event});

  final Event event;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;

    await fcm.requestPermission();

    fcm.subscribeToTopic('chat_${widget.event.id}');

    // final token = await fcm.getToken();
    // print(token); // could send this to backend
  }

  @override
  void initState() {
    super.initState();

    setupPushNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.title),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.exit_to_app,
                color: Theme.of(context).colorScheme.primary),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(child: ChatMessages(event: widget.event)),
          NewMessage(event: widget.event),
        ],
      ),
    );
  }
}
