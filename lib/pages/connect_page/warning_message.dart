import 'package:flutter/material.dart';

class WarningMessage extends StatelessWidget {
  final String msg;
  const WarningMessage({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          subtitle: Text(msg),
          isThreeLine: true,
        )
      ],
    );
  }
}
