import 'package:flutter/material.dart';
import 'package:zeeyou/tools/hsl_color.dart';

class FunctionContainer extends StatelessWidget {
  const FunctionContainer({
    super.key,
    required this.color,
    required this.veryLightColor,
    required this.icon,
    required this.title,
    this.child,
    this.disabled = false,
  });

  final Color color;
  final Color veryLightColor;
  final IconData icon;
  final String title;
  final Widget? child;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          color: disabled ? Colors.grey[200] : veryLightColor,
          width: double.infinity,
          height: 70,
          child: Row(
            children: [
              const SizedBox(width: 25),
              Icon(icon, color: color, size: 33),
              const SizedBox(width: 20),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
        const SizedBox(height: 20),
        child ?? Text('Nothing in here'),
      ],
    );
  }
}
