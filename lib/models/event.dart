import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:zeeyou/models/place.dart';
import 'package:zeeyou/tools/hsl_color.dart';
import 'package:zeeyou/tools/string_extension.dart';

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
    required this.organizedBy,
    required this.color,
    this.isFavorite = false,
    required this.id,
  })  : formatedDate =
            date != null ? DateFormat.yMMMMEEEEd().format(date) : null,
        lightColor = changeColorLigntness(color, 0.85);

  final String id;

  final String title;
  final String? description;
  DateTime? date;
  final String? formatedDate;
  final IconData? icon;
  PlaceLocation? location;
  final EventType? type;
  final String organizedBy;
  final Color color;
  final Color lightColor;
  final bool isFavorite;
}
