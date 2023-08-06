import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zeeyou/models/event.dart';
import 'package:zeeyou/providers/events_provider.dart';
import 'package:zeeyou/screens/chat.dart';
import 'package:zeeyou/widgets/add_event_button.dart';
import 'package:zeeyou/widgets/event_card.dart';
import 'package:zeeyou/widgets/user_icon.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Event> events = ref.watch(eventsProvider);

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
                    builder: (ctx) => ChatScreen(
                        chatId: 'staff', title: 'Discute avec nous !')));
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
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
        child: Column(
          children: [
            const AddEventButton(),
            Expanded(
              child: ListView.builder(
                itemCount: events.length + 1,
                itemBuilder: (ctx, index) {
                  if (index == 0) {
                    // return the header
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Text('Evenements',
                            style: Theme.of(context).textTheme.headlineSmall),
                      ),
                    );
                  }
                  index -= 1;

                  return EventCard(event: events[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
