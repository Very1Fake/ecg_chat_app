import 'package:flutter/material.dart';

class BottomProgressIndicator extends LinearProgressIndicator
    implements PreferredSizeWidget {
  @override
  final Size preferredSize = const Size(double.infinity, 6.0);

  const BottomProgressIndicator({
    super.key,
    super.value,
    super.backgroundColor,
    super.valueColor,
  });
}
