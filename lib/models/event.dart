import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:zeeyou/models/place.dart';
import 'package:zeeyou/tools/hsl_color.dart';
import 'package:zeeyou/tools/string_extension.dart';

enum EventType {
  none,
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
    required this.organizedBy,
    required this.type,
    required this.icon,
    required this.color,
    this.isFavorite = false,
    required this.id,
  })  : formatedDate =
            date != null ? DateFormat.yMMMMEEEEd().format(date) : null,
        typeName = type.name.capitalize(),
        lightColor = changeColorLigntness(color, 0.85);

  final String id;

  final String title;
  final String? description;
  final DateTime? date;
  final String? formatedDate;
  PlaceLocation? location;
  final String organizedBy;
  final EventType type;
  final String typeName;
  final IconData icon;
  final Color color;
  final Color lightColor;
  final bool isFavorite;
}
