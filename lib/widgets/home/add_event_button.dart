import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zeeyou/models/event.dart';
import 'package:zeeyou/providers/events_provider.dart';
import 'package:zeeyou/screens/set_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddEventButton extends ConsumerWidget {
  const AddEventButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () async {
        final Event? newEvent = await Navigator.of(context)
            .push(MaterialPageRoute(builder: (ctx) => const SetEventScreen()));
        if (newEvent != null) {
          ref.read(eventsProvider.notifier).addEvent(newEvent);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [
                -0.2,
                0.4,
              ],
              colors: [
                Color(0xBFFFBA2C),
                Color(0xFFFEE7B8),
              ],
            ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.createNewEvent,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            const Icon(Icons.arrow_forward, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
