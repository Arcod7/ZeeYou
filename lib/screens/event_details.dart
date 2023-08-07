import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:zeeyou/models/event.dart';
import 'package:zeeyou/screens/chat.dart';
import 'package:zeeyou/widgets/event_details/event_deails_header.dart';

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({
    super.key,
    required this.event,
    required this.databaseId,
  });

  final Event event;
  final String databaseId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: event.lightColor,
        actions: [
          IconButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('events')
                  .doc(databaseId)
                  .delete();
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.delete_outline),
          ),
          PopupMenuButton(
            itemBuilder: (ctx) => [
              PopupMenuItem(child: const Text('Donate ?'), onTap: () {}),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Expanded(
          child: Container(
            color: event.lightColor,
            width: double.infinity,
            child: Container(
              width: 20,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(44)),
                color: Theme.of(context).colorScheme.background,
              ),
              child: Column(
                children: [
                  EventDetailsHeader(event: event),
                  ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(event.lightColor),
                      foregroundColor: MaterialStateProperty.all(event.color),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => ChatScreen(
                            chatType: 'event_chat',
                            chatId: event.id,
                            title: event.title,
                          ),
                        ),
                      );
                    },
                    icon: Icon(MdiIcons.chat),
                    label: const Text('Messages'),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Column(
        //   children: [
        //     Text(event.title),
        //   ],
        // )
      ),
    );
  }
}
