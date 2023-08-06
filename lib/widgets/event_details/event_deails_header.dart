import 'package:flutter/material.dart';
import 'package:zeeyou/models/event.dart';
import 'package:zeeyou/tools/string_extension.dart';
import 'package:zeeyou/widgets/event_details/details_date.dart';
import 'package:zeeyou/widgets/event_details/details_location.dart';

class EventDetailsHeader extends StatelessWidget {
  const EventDetailsHeader({
    super.key,
    required this.event,
  });

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: Icon(
                Icons.favorite,
                color: event.color,
              ),
              onPressed: () {},
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.type.name.capitalize(),
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: Colors.black26),
                ),
                Text(event.title,
                    style: Theme.of(context).textTheme.titleLarge),
                Text(event.description ?? 'ya R à dire'),
                EventDetailsDate(
                  color: event.color,
                  onDatePicked: (date) {},
                  date: event.date ?? DateTime.now(),
                ),
                EventDetailsLocation(
                  color: event.color,
                  lightColor: event.lightColor,
                  onLocationPicked: (newLoc) {
                    event.location = newLoc;
                  },
                  location: event.location,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
