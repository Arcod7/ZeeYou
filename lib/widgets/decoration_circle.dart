import 'package:flutter/material.dart';

class DecorationCircle extends StatelessWidget {
  const DecorationCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Theme.of(context).colorScheme.inversePrimary,
            Theme.of(context).colorScheme.inversePrimary.withOpacity(0.4)
          ],
        ),
      ),
    );
  }
}
