import 'package:flutter/material.dart';
import 'package:zeeyou/models/event.dart';
import 'package:zeeyou/tools/string_extension.dart';

class EventDetailsHeader extends StatelessWidget {
  const EventDetailsHeader({
    super.key,
    required this.event,
  });

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 25, right: 25, top: 50),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: Icon(
                event.icon,
                color: event.colors.primary,
                size: 35,
              ),
              onPressed: () {},
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (event.type != null)
                Text(
                  event.type!.name.capitalize(),
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: Colors.black26),
                ),
              Hero(
                  tag: event.id + event.title,
                  child: Text(event.title,
                      style: Theme.of(context).textTheme.titleLarge)),
              const SizedBox(height: 10),
              Text(event.description ?? ''),
            ],
          ),
        ],
      ),
    );
  }
}
