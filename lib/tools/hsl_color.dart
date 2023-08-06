import 'package:flutter/material.dart';

Color increaseColorSaturation(Color color, double value) =>
    HSLColor.fromColor(color)
        .withSaturation(HSLColor.fromColor(color).saturation + value)
        .toColor();

Color increaseColorLigntness(Color color, double value) =>
    HSLColor.fromColor(color)
        .withLightness(HSLColor.fromColor(color).lightness + value)
        .toColor();

Color changeColorLigntness(Color color, double value) =>
    HSLColor.fromColor(color).withLightness(value).toColor();

Color changeColorHue(Color color, double hue) =>
    HSLColor.fromColor(color).withHue(hue).toColor();
