import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final IconData icon;
  final bool container;
  final bool transparent;

  const Avatar(
      {super.key,
      this.icon = Icons.person,
      this.container = false,
      this.transparent = false});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return CircleAvatar(
      backgroundColor: transparent
          ? Colors.transparent
          : container
              ? colorScheme.primaryContainer
              : colorScheme.primary,
      child: Icon(
        icon,
        color:
            container ? colorScheme.onPrimaryContainer : colorScheme.onPrimary,
      ),
    );
  }
}
