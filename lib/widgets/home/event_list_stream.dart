import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zeeyou/models/event.dart';
import 'package:zeeyou/models/place.dart';
import 'package:zeeyou/widgets/home/event_card.dart';

class EventListStream extends StatelessWidget {
  const EventListStream({super.key});

  Event _getEvent(final event) => Event(
        title: event['title'],
        description: event['description'],
        organizedBy: event['organizedBy'],
        type: EventType.values.firstWhere((e) => e.toString() == event['type']),
        icon: IconData(
          event['icon']['codePoint'],
          fontFamily: event['icon']['fontFamily'],
          fontPackage: event['icon']['fontPackage'],
        ),
        color: Color.fromARGB(
          255,
          event['color'][0],
          event['color'][1],
          event['color'][2],
        ),
        date: event['date'] != null
            ? (event['date'] as Timestamp).toDate()
            : null,
        location: event['location'] != null
            ? PlaceLocation(
                latitude: event['location']['lat'],
                longitude: event['location']['lng'],
                address: event['location']['address'],
              )
            : null,
        id: event['id'],
      );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('events')
            .orderBy('updatedAt', descending: true)
            .snapshots(),
        builder: (ctx, eventSnapshots) {
          if (eventSnapshots.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!eventSnapshots.hasData || eventSnapshots.data!.docs.isEmpty) {
            return const Center(
              child: Text("Pas d'events pour l'instant"),
            );
          }

          if (eventSnapshots.hasError) {
            return const Center(
              child: Text('Ya un prb là frr'),
            );
          }

          final loadedEvents = eventSnapshots.data!.docs;

          return ListView.builder(
            itemCount: loadedEvents.length + 1,
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

              final loadedEvent = _getEvent(loadedEvents[index].data());

              return EventCard(event: loadedEvent, databaseId: loadedEvents[index].id);
            },
          );
        });
  }
}
