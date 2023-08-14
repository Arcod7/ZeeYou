import 'package:flutter/material.dart';

Color increaseColorSaturation(Color color, double value) =>
    HSLColor.fromColor(color)
        .withSaturation(HSLColor.fromColor(color).saturation + value)
        .toColor();

Color increaseColorLightness(Color color, double value) =>
    HSLColor.fromColor(color)
        .withLightness(HSLColor.fromColor(color).lightness + value)
        .toColor();

Color changeColorLightness(Color color, double value) =>
    HSLColor.fromColor(color).withLightness(value).toColor();

Color changeColorHue(Color color, double hue) =>
    HSLColor.fromColor(color).withHue(hue).toColor();
