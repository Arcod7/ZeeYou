import 'package:flutter/material.dart';

class ThemeCard extends StatelessWidget {
  const ThemeCard({
    super.key,
    required this.boxColor,
    required this.textColor,
    this.text = 'Test',
  });

  final Color boxColor;
  final Color textColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: boxColor,
        boxShadow: const [BoxShadow(spreadRadius: 1)],
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}

class ThemeTestScreen extends StatelessWidget {
  const ThemeTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Test your theme !')),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 4 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          children: [
            ThemeCard(
              boxColor: s.primary,
              textColor: s.onPrimary,
              text: 'primary',
            ),
            ThemeCard(
              boxColor: s.primaryContainer,
              textColor: s.onPrimaryContainer,
              text: 'primary container',
            ),
            ThemeCard(
              boxColor: s.secondary,
              textColor: s.onSecondary,
              text: 'secondary',
            ),
            ThemeCard(
              boxColor: s.secondaryContainer,
              textColor: s.onSecondaryContainer,
              text: 'secondary container',
            ),
            ThemeCard(
              boxColor: s.tertiary,
              textColor: s.onTertiary,
              text: 'tertiary',
            ),
            ThemeCard(
              boxColor: s.tertiaryContainer,
              textColor: s.onTertiaryContainer,
              text: 'tertiary container',
            ),
            ThemeCard(
              boxColor: s.error,
              textColor: s.onError,
              text: 'error',
            ),
            ThemeCard(
              boxColor: s.errorContainer,
              textColor: s.onErrorContainer,
              text: 'error container',
            ),
            ThemeCard(
              boxColor: s.surface,
              textColor: s.onSurface,
              text: 'surface',
            ),
            ThemeCard(
              boxColor: s.inverseSurface,
              textColor: s.onInverseSurface,
              text: 'inverse surface',
            ),
            ThemeCard(
              boxColor: s.background,
              textColor: s.onBackground,
              text: 'background',
            ),
            ThemeCard(
              boxColor: s.inversePrimary,
              textColor: s.onInverseSurface,
              text: 'inverse primary',
            ),
            ThemeCard(
              boxColor: s.surfaceVariant,
              textColor: s.onSurfaceVariant,
              text: 'surface variant',
            ),
          ],
        ),
      ),
    );
  }
}
