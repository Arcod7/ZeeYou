import 'package:flutter/material.dart';
import 'package:zeeyou/models/event.dart';
import 'package:zeeyou/tools/string_extension.dart';
import 'package:zeeyou/widgets/event_details/details_date.dart';
import 'package:zeeyou/widgets/event_details/details_location.dart';

class EventDetailsHeader extends StatefulWidget {
  const EventDetailsHeader({
    super.key,
    required this.event,
  });

  final Event event;

  @override
  State<EventDetailsHeader> createState() => _EventDetailsHeaderState();
}

class _EventDetailsHeaderState extends State<EventDetailsHeader> {
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
                color: widget.event.color,
              ),
              onPressed: () {},
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.event.type.name.capitalize(),
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: Colors.black26),
                ),
                Text(widget.event.title,
                    style: Theme.of(context).textTheme.titleLarge),
                Text(widget.event.description ?? 'ya R à dire'),
                EventDetailsDate(
                  color: widget.event.color,
                  onDatePicked: (date) {},
                  date: widget.event.date ?? DateTime.now(),
                ),
                EventDetailsLocation(
                  color: widget.event.color,
                  lightColor: widget.event.lightColor,
                  onLocationPicked: (newLoc) {
                    setState(() {
                      widget.event.location = newLoc;
                    });
                  },
                  location: widget.event.location,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
