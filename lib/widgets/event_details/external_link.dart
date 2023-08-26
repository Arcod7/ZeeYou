import 'package:flutter/material.dart';
import 'package:zeeyou/models/color_shade.dart';

class ExternalLink extends StatelessWidget {
  const ExternalLink({
    super.key,
    this.text,
    required this.icon,
    required this.colors,
    this.onTap,
    this.isDisabled = false,
    this.isNone = false,
    this.title,
    this.isGetting = false,
  });

  final String? text;
  final IconData icon;
  final ColorShade colors;
  final void Function()? onTap;
  final bool isDisabled;
  final bool isNone;
  final Widget? title;
  final bool isGetting;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colors.light,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Icon(
          icon,
          color: colors.primary,
          size: 23,
        ),
      ),
      title: title ??
          (text != null
              ? Text(text!,
                  style: TextStyle(
                      color: isNone ? Colors.grey[600] : colors.primary))
              : null),
      trailing: isGetting ? const CircularProgressIndicator.adaptive() : null,
    );
  }
}
