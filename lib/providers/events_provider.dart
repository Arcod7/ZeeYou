import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zeeyou/data/dummy_events.dart';
import 'package:zeeyou/models/event.dart';

class EventsNotifier extends StateNotifier<List<Event>> {
  EventsNotifier() : super([...dummyEvents]);

  void addEvent(Event event) {
    state = [...state, event];
  }
}

final eventsProvider = StateNotifierProvider<EventsNotifier, List<Event>>(
    (ref) => EventsNotifier());
