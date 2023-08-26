import 'package:flutter/material.dart';
import 'package:zeeyou/models/color_shade.dart';

class FunctionContainer extends StatelessWidget {
  const FunctionContainer({
    super.key,
    required this.colors,
    required this.icon,
    required this.title,
    this.child,
    this.isDisabled = false,
  });

  final ColorShade colors;
  final IconData icon;
  final String title;
  final Widget? child;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          color: isDisabled ? Colors.grey[200] : colors.veryLight,
          width: double.infinity,
          height: 70,
          child: Row(
            children: [
              const SizedBox(width: 25),
              Icon(icon,
                  color: isDisabled ? Colors.grey[600] : colors.primary,
                  size: 33),
              const SizedBox(width: 20),
              Text(title,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: isDisabled ? Colors.grey[600] : colors.primary)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        child ?? Text('Nothing in here'),
      ],
    );
  }
}
