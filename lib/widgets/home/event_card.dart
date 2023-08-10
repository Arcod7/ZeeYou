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

  String _getTimeDifference(DateTime date) {
    // final String currentDate = DateFormat.yMMMMEEEEd().format(date);
    final difference = date.difference(DateTime.now());
    String returnString = '';

    if (!difference.isNegative) {
      returnString += 'in ';
    }
    if (difference.abs().inHours <= 1) {
      returnString += '${difference.abs().inMinutes.toString()} minutes';
    } else if (difference.abs().inDays <= 1) {
      returnString += '${difference.abs().inHours.toString()} hours';
    } else {
      returnString += '${difference.abs().inDays.toString()} days';
    }
    if (difference.isNegative) {
      returnString += ' ago';
    }

    return returnString;
    // return '$currentDate\n$returnString';
  }

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
          leading: event.date != null
              ? Container(
                  alignment: Alignment.center,
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: event.lightColor,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    _getTimeDifference(event.date!),
                    style: const TextStyle(color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                )
              : null,
          title:
              Text(event.title, style: Theme.of(context).textTheme.titleMedium),
          subtitle: Text(
              '${event.type.name.capitalize()} organisé par ${event.organizedBy}'),
        ),
        if (event.icon != null)
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
