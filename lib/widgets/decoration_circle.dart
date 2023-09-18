import 'package:flutter/material.dart';

class DecorationCircle extends StatelessWidget {
  const DecorationCircle({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double radius = size.width > size.height ? size.width : size.height;
    radius = radius * 0.25;
    return Material(
      elevation: 4,
      shape: const CircleBorder(),
      child: Container(
        width: radius,
        height: radius,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              Theme.of(context).colorScheme.inversePrimary,
              Theme.of(context).colorScheme.inversePrimary.withOpacity(0.7),
            ],
          ),
        ),
      ),
    );
  }
}
