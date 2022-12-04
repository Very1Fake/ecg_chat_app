import 'package:flutter/material.dart';

class SimpleDialogTile extends StatelessWidget {
  const SimpleDialogTile(
      {super.key, this.leading, this.title, this.trailing, this.onPressed});

  final Widget? leading;
  final Widget? title;
  final Widget? trailing;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: onPressed,
      child: Row(
        children: [
          if (leading != null) leading!,
          if (leading != null) const SizedBox(width: 24),
          if (title != null) title!,
          if (trailing != null) const Spacer(),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
