import 'package:flutter/material.dart';

InputDecoration textInputDecoration(String label) => InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(10),
      ),
      filled: true,
      // fillColor: Colors.grey[300],
      labelText: label,
    );
