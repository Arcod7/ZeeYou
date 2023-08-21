import 'package:flutter/material.dart';

import 'package:zeeyou/models/place.dart';
import 'package:zeeyou/tools/color_shade.dart';

enum EventType {
  soiree,
  anniversaire,
  mariage,
  roadtrip,
  cinema,
}

class Event {
  Event({
    required this.title,
    this.description,
    this.date,
    this.location,
    this.icon,
    this.type,
    this.maxPeople,
    required this.organizedBy,
    required this.colors,
    this.isFavorite = false,
    required this.id,
  });
  // lightColor: changeColorLigntness(color, 0.85);

  String id;

  String title;
  String? description;
  DateTime? date;
  IconData? icon;
  PlaceLocation? location;
  EventType? type;
  int? maxPeople;
  String organizedBy;
  ColorShade colors;
  bool isFavorite;
}
