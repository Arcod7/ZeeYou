import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zeeyou/models/event.dart';
import 'package:zeeyou/screens/chat.dart';
import 'package:zeeyou/screens/event_details.dart';
import 'package:zeeyou/tools/string_extension.dart';
import 'package:zeeyou/l10n/app_localizations.dart';
import 'package:timeago/timeago.dart' as timeago;

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

class ChatIconButton extends StatelessWidget {
  const ChatIconButton({
    super.key,
    required this.color,
    required this.onPressed,
  });

  final Color color;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.only(right: 12, top: 7, bottom: 10, left: 10),
        child: Icon(Icons.chat_bubble_outline, size: 25, color: color),
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

  void openEventDetails(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => EventDetailsScreen(event: event))
        // PageTransition(
        //   ctx: context,
        //   type: PageTransitionType.bottomToTop,
        //   child: EventDetailsScreen(event: event),
        // ),
        );
  }

  String formatDateThreeLines(DateTime date, String locale) {
    String formattedDate =
        DateFormat.yMMMMEEEEd(locale).format(date).capitalize();

    if (locale == 'es') {
      return formattedDate.replaceAll(" de", "\nde");
    } else if (locale == 'en') {
      List<String> splittedDate = formattedDate.split(' ');
      return "${splittedDate[0]}\n${splittedDate[1].capitalize()}\n${splittedDate[2]}  ${splittedDate[3]}";
    } else if (locale == 'fr') {
      List<String> splittedDate = formattedDate.split(' ');
      return "${splittedDate[0]} ${splittedDate[1]}\n${splittedDate[2].capitalize()}\n${splittedDate[3]}";
    } else {
      return "Locale unknown";
    }
  }

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('fr', timeago.FrMessages());
    final l10n = AppLocalizations.of(context)!;
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
          onTap: () => openChatScreen(
            context,
            event,
            onTitlePress: () => openEventDetails(context),
          ),
          visualDensity: const VisualDensity(vertical: 3),
          leading: GestureDetector(
            onTap: () => openEventDetails(context),
            child: Container(
                alignment: Alignment.center,
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: event.colors.light,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    event.date != null
                        ? formatDateThreeLines(event.date!, l10n.locale)
                        //"${DateFormat("EEEE d", l10n.locale).format(event.date!).capitalize()}${DateFormat("MMMM", l10n.locale).format(event.date!).capitalize()}${DateFormat("y", l10n.locale).format(event.date!)}"
                        : l10n.chooseDate.replaceFirst(' ', '\n'),
                    style: const TextStyle(
                        color: Colors.black87,
                        height: 1.6,
                        overflow: TextOverflow.ellipsis),
                    textAlign: TextAlign.center,
                  ),
                )),
          ),
          title: Hero(
              tag: event.id + event.title,
              child: Text(event.title,
                  style: Theme.of(context).textTheme.titleMedium)),
          subtitle: Text(
            (event.type != null ? event.type!.name.capitalize() : '') +
                l10n.organizedBy +
                event.organizedBy,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (event.icon != null)
          Positioned(
            bottom: 10,
            right: 10,
            child: Icon(
              event.icon,
              size: 25,
              color: event.colors.primary,
            ),
          ),
        // Positioned(
        //   top: -2,
        //   right: -2,
        //   child: ChatIconButton(
        //     color: event.colors.primary,
        //     onPressed: () => openChatScreen(context, event),
        //   ), //FavortiteIconButton(color: event.colors.primary),
        // ),
      ]),
    );
  }
}
