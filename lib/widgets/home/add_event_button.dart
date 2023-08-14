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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(150, 255, 187, 57),
              Color.fromARGB(150, 255, 116, 116),
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              l10n.createNewEvent,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            const Icon(Icons.add, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
