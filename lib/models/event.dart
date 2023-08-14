import 'package:flutter/material.dart';

import 'package:zeeyou/models/place.dart';
import 'package:zeeyou/tools/hsl_color.dart';

enum EventType {
  soiree,
  anniversaire,
  mariage,
  roadtrip,
  cinema,
}

class ColorShade {
  ColorShade({required this.colorHue});

  final double colorHue;
  get color => changeColorHue(
      changeColorLightness(
        const Color.fromARGB(255, 255, 199, 135),
        0.3,
      ),
      colorHue);
  get lightColor => changeColorLightness(color, 0.85);
  get veryLightColor => changeColorLightness(color, 0.93);
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
    required this.colorHue,
    this.isFavorite = false,
    required this.id,
  });
  // lightColor: changeColorLigntness(color, 0.85);

  final String id;

  final String title;
  final String? description;
  DateTime? date;
  final IconData? icon;
  PlaceLocation? location;
  final EventType? type;
  final int? maxPeople;
  final String organizedBy;
  final double colorHue;
  late final Color color = changeColorHue(
      changeColorLightness(
        const Color.fromARGB(255, 255, 199, 135),
        0.3,
      ),
      colorHue);
  late final Color lightColor = changeColorLightness(color, 0.85);
  late final Color veryLightColor = changeColorLightness(color, 0.94);
  final bool isFavorite;
}
