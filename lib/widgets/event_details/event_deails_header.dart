import 'package:cloud_firestore/cloud_firestore.dart';
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
                widget.event.icon,
                color: widget.event.colors.primary,
                size: 35,
              ),
              onPressed: () {},
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.event.type != null)
                Text(
                  widget.event.type!.name.capitalize(),
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: Colors.black26),
                ),
              Text(widget.event.title,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              Text(widget.event.description ?? ''),
              const SizedBox(height: 20),
              EventDetailsDate(
                color: widget.event.colors.primary,
                onDatePicked: (newDate) {
                  FirebaseFirestore.instance
                      .collection('events')
                      .doc(widget.event.id)
                      .update({'date': Timestamp.fromDate(newDate)});
                  setState(() => widget.event.date = newDate);
                },
                date: widget.event.date,
              ),
              EventDetailsLocation(
                color: widget.event.colors.primary,
                lightColor: widget.event.colors.light,
                onLocationPicked: (newLoc) {
                  FirebaseFirestore.instance
                      .collection('events')
                      .doc(widget.event.id)
                      .update({
                    'location': {
                      'lat': newLoc.latitude,
                      'lng': newLoc.longitude,
                      'address': newLoc.address,
                    }
                  });
                  setState(() => widget.event.location = newLoc);
                },
                location: widget.event.location,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
