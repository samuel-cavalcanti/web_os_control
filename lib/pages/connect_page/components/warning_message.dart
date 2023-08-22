import 'package:flutter/material.dart';

class WarningMessage extends StatelessWidget {
  final String msg;
  const WarningMessage({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            msg,
            maxLines: 3,
          ),
        ),
      ],
    );
  }
}
