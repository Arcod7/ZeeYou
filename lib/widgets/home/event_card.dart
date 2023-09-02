import 'package:flutter/material.dart';
import 'package:zeeyou/models/event.dart';
import 'package:zeeyou/screens/chat.dart';
import 'package:zeeyou/screens/event_details.dart';
import 'package:zeeyou/tools/string_extension.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
                child: Text(
                  event.date != null
                      ? timeago.format(
                          DateTime.now()
                              .add(event.date!.difference(DateTime.now())),
                          locale: Localizations.localeOf(context).languageCode,
                          allowFromNow: true)
                      : l10n.chooseDate,
                  style: const TextStyle(color: Colors.black87),
                  textAlign: TextAlign.center,
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
