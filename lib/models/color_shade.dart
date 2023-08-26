import 'package:flutter/material.dart';
import 'package:zeeyou/tools/hsl_color.dart';

ColorShade getColorShade(double colorHue) {
  Color primary = changeColorHue(
      changeColorLightness(const Color.fromARGB(255, 255, 199, 135), 0.3),
      colorHue);

  return ColorShade(
    colorHue: colorHue,
    primary: primary,
    light: changeColorLightness(primary, 0.85),
    veryLight: changeColorLightness(primary, 0.94),
  );
}

class ColorShade {
  ColorShade({
    required this.colorHue,
    required this.primary,
    required this.light,
    required this.veryLight,
  });

  final double colorHue;
  final Color primary;
  final Color light;
  final Color veryLight;
}
