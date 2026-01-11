import 'package:flutter/material.dart';

/// A widget that dismisses the keyboard when tapping outside text fields
class KeyboardDismisser extends StatelessWidget {
  final Widget child;

  const KeyboardDismisser({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Unfocus any focused text field
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.translucent,
      child: child,
    );
  }
}
