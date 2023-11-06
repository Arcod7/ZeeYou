import 'package:flutter/material.dart';
import 'package:zeeyou/widgets/home/add_event_button.dart';
import 'package:zeeyou/widgets/home/home_circle.dart';
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
        centerTitle: false,
        title: Text('ZeeYouCuauh',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: const [MoreButton()],
      ),
      backgroundColor: Colors.blueGrey[70],
      body: const Padding(
        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 0),
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
