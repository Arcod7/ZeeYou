import 'package:flutter/material.dart';
import 'package:zeeyou/models/event.dart';
import 'package:zeeyou/widgets/event_details/event_deails_header.dart';

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({
    super.key,
    required this.event,
  });

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: event.lightColor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz),
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
              child: EventDetailsHeader(event: event),
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
