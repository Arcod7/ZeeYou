import 'package:flutter/material.dart';
import 'package:zeeyou/widgets/home/add_event_button.dart';
import 'package:zeeyou/widgets/home/event_list_stream.dart';
import 'package:zeeyou/widgets/home/more_button.dart';
import 'package:zeeyou/widgets/user_icon.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final List<Event> events = ref.watch(eventsProvider);
    return Scaffold(
      appBar: AppBar(
        leading: const UserIcon(),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        centerTitle: true,
        title: Text('ZeeYou',
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        actions: const [MoreButton()],
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
