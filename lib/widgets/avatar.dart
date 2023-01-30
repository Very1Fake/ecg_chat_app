import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final IconData icon;
  final bool container;
  final bool transparent;
  final bool tertiary;
  final double radius;

  const Avatar(
      {super.key,
      this.icon = Icons.person,
      this.container = false,
      this.transparent = false,
      this.tertiary = false,
      this.radius = 20.0});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return CircleAvatar(
      backgroundColor: transparent
          ? Colors.transparent
          : container
              ? tertiary
                  ? colorScheme.tertiaryContainer
                  : colorScheme.primaryContainer
              : tertiary
                  ? colorScheme.tertiary
                  : colorScheme.primary,
      radius: radius,
      child: Icon(
        icon,
        color: container
            ? tertiary
                ? colorScheme.onTertiaryContainer
                : colorScheme.onPrimaryContainer
            : tertiary
                ? colorScheme.onTertiary
                : colorScheme.onPrimary,
      ),
    );
  }
}
