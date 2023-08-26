import 'package:flutter/material.dart';
import 'package:zeeyou/models/color_shade.dart';

InputDecoration textInputDecoration(String label) => InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(10),
      ),
      filled: true,
      // fillColor: Colors.grey[300],
      labelText: label,
    );

InputDecoration externalLinkInputDecoration(String label, ColorShade color) =>
    InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(15),
      ),
      filled: true,
      fillColor: color.veryLight,
      labelText: label,
      labelStyle: TextStyle(color: color.primary),
      focusColor: color.primary,
      hoverColor: color.primary,
    );
