import 'package:flutter/material.dart';

class TileAvatarIcon extends StatelessWidget {
  const TileAvatarIcon(this.icon, {super.key, this.radius = 18.0});

  final IconData icon;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: radius,
      child: Icon(
        icon,
        color: Theme.of(context).colorScheme.onBackground,
        size: radius * 1.5,
      ),
    );
  }
}

class TileAvatarColor extends StatelessWidget {
  const TileAvatarColor(this.color, {super.key, this.char, this.radius = 18.0});

  final Color color;
  final String? char;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: color,
      radius: radius,
      child: char != null
          ? Text(char!,
              style: TextStyle(color: Colors.white, fontSize: radius * 1.25))
          : null,
    );
  }
}
