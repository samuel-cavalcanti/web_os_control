import 'package:flutter/material.dart';

class RoundedContainer extends StatelessWidget {
  final Widget child;
  const RoundedContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: _roundedBox(Theme.of(context).colorScheme.onSurface),
        child: child);
  }

  BoxDecoration _roundedBox(Color c) =>
      BoxDecoration(color: c, borderRadius: BorderRadius.circular(8));
}
