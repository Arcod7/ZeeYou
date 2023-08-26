import 'package:flutter/material.dart';

import 'package:zeeyou/models/place.dart';
import 'package:zeeyou/models/color_shade.dart';

enum EventType {
  soiree,
  anniversaire,
  mariage,
  roadtrip,
  cinema,
  chill,
}

class Event {
  Event({
    required this.title,
    this.description,
    this.icon,
    this.date,
    this.location,
    required this.colors,
    this.type,
    required this.organizedBy,
    this.maxPeople,
    required this.links,
    this.isFavorite = false,
    required this.id,
  });

  String id;

  String title;
  String? description;
  IconData? icon;
  DateTime? date;
  PlaceLocation? location;
  ColorShade colors;
  EventType? type;
  String organizedBy;
  int? maxPeople;
  Map<String, dynamic> links;
  bool isFavorite;
}
