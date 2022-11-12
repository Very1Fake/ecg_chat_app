import 'package:flutter/material.dart';

class CenteredIconMessage extends StatelessWidget {
  final IconData icon;
  final String text;

  const CenteredIconMessage(this.icon, this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64.0,
            color: theme.hintColor,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24.0,
              color: theme.hintColor,
            ),
          )
        ],
      ),
    );
  }
}
