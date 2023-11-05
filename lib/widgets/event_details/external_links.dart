import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:zeeyou/models/event.dart';
import 'package:zeeyou/widgets/event_details/link_date.dart';
import 'package:zeeyou/widgets/event_details/link_location.dart';
import 'package:zeeyou/widgets/event_details/external_link.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExternalLinks extends StatefulWidget {
  const ExternalLinks({
    super.key,
    required this.event,
  });

  final Event event;

  @override
  State<ExternalLinks> createState() => _ExternalLinksState();
}

class _ExternalLinksState extends State<ExternalLinks> {
  @override
  Widget build(BuildContext context) {
    final links = widget.event.links;
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          LinkDate(
            colors: widget.event.colors,
            onDatePicked: (newDate) {
              FirebaseFirestore.instance
                  .collection('events')
                  .doc(widget.event.id)
                  .update({'date': Timestamp.fromDate(newDate)});
              setState(() => widget.event.date = newDate);
            },
            date: widget.event.date,
          ),
          LinkLocation(
            colors: widget.event.colors,
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
          if (links.containsKey('Photos') && links['Photos'] != '')
            ExternalLink(
              text: l10n.photos,
              icon: Icons.calendar_today_outlined,
              colors: widget.event.colors,
              onTap: () {
                launchUrlString(
                  links['Photos'],
                  mode: LaunchMode.externalApplication,
                );
              },
            ),
          if (links.containsKey('Music') && links['Music'] != '')
            ExternalLink(
              text: l10n.music,
              icon: MdiIcons.music,
              colors: widget.event.colors,
              onTap: () {
                launchUrlString(
                  links['Music'],
                  mode: LaunchMode.externalApplication,
                );
              },
            ),
          if (links.containsKey('Meet') && links['Meet'] != '')
            ExternalLink(
              text: l10n.meet,
              icon: Icons.meeting_room_outlined,
              colors: widget.event.colors,
              onTap: () {
                launchUrlString(
                  links['Meet'],
                  mode: LaunchMode.externalApplication,
                );
              },
            ),
        ],
      ),
    );
  }
}
