import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:zeeyou/models/event.dart';

final dummyEvents = [
  Event(
    id: 'a',
    title: 'Projet X chez Gérard',
    date: DateTime.now(),
    // location: '3 Rue des Paresseux, 61130 Igé',
    organizedBy: 'Antoine',
    type: EventType.anniversaire,
    icon: MdiIcons.partyPopper,
    color: const Color.fromARGB(255, 254, 196, 93),
  ),
  Event(
    id: 'b',
    title: 'Mariage Tata',
    date: DateTime.now(),
    // location: '3 Rue des Paresseux, 61130 Igé',
    organizedBy: 'Francine',
    type: EventType.mariage,
    icon: MdiIcons.ring,
    color: const Color.fromARGB(255, 255, 194, 194),
  ),
  Event(
    id: 'c',
    title: 'Pool Party',
    date: DateTime.now(),
    // location: '3 Rue des Paresseux, 61130 Igé',
    organizedBy: 'Sylvain Durif',
    type: EventType.soiree,
    icon: MdiIcons.pool,
    color: const Color.fromARGB(255, 255, 172, 251),
  ),
  Event(
    id: 'd',
    title: 'Khapta chez Jean',
    date: DateTime.now(),
    // location: '3 Rue des Paresseux, 61130 Igé',
    organizedBy: 'Jean',
    type: EventType.soiree,
    icon: MdiIcons.volleyball,
    color: const Color.fromARGB(255, 132, 200, 243),
  ),
];
