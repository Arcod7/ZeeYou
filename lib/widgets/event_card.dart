import 'package:flutter/material.dart';
import 'package:zeeyou/models/event.dart';
import 'package:zeeyou/screens/event_details.dart';
import 'package:zeeyou/tools/string_extension.dart';

class FavortiteIconButton extends StatefulWidget {
  const FavortiteIconButton({super.key, this.color = Colors.white});

  final Color color;

  @override
  State<FavortiteIconButton> createState() => _FavortiteIconButtonState();
}

class _FavortiteIconButtonState extends State<FavortiteIconButton> {
  var isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isFavorite = !isFavorite;
        });
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.only(
          right: 12,
          top: 7,
          bottom: 10,
          left: 10,
        ),
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_outline,
          size: 25,
          color: widget.color,
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
  });

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(vertical: 5),
      alignment: Alignment.center,
      child: Stack(children: [
        ListTile(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => EventDetailsScreen(
                    event: event))); // ChatScreen(event: event)));
          },
          visualDensity: const VisualDensity(vertical: 3),
          leading: Container(
            alignment: Alignment.center,
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: event.color,
            ),
            child: const Text(
              'Jeudi\n2\nJuillet',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          title:
              Text(event.title, style: Theme.of(context).textTheme.titleMedium),
          subtitle: Text(
              '${event.type.name.capitalize()} organisé par ${event.organizedBy}'),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: Icon(
            event.icon,
            size: 22,
            color: event.color,
          ),
        ),
        Positioned(
          top: -2,
          right: -2,
          child: FavortiteIconButton(color: event.color),
        ),
      ]),
    );
  }
}
