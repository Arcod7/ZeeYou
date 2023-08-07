import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zeeyou/screens/chat.dart';
import 'package:zeeyou/widgets/home/add_event_button.dart';
import 'package:zeeyou/widgets/home/event_list_stream.dart';
import 'package:zeeyou/widgets/user_icon.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final List<Event> events = ref.watch(eventsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const UserIcon(),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        centerTitle: true,
        title: Text('ZeeYou',
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => const ChatScreen(
                        chatType: 'staff_chat',
                        chatId: 'staff',
                        title: 'Discute avec nous !')));
              },
              icon: Icon(Icons.settings_outlined,
                  color: Theme.of(context).colorScheme.onPrimary)),
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.exit_to_app,
                color: Theme.of(context).colorScheme.onPrimary),
          )
        ],
      ),
      backgroundColor: Colors.blueGrey[50],
      body: const Padding(
        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
        child: Column(
          children: [
            AddEventButton(),
            Expanded(
              child: EventListStream(),
            ),
          ],
        ),
      ),
    );
  }
}
