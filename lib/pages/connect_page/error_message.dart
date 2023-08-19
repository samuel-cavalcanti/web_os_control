import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String msg;
  const ErrorMessage({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text(
            'Error $msg',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.merge(const TextStyle(fontWeight: FontWeight.bold)),
          ),
          subtitle: const Text(
              'No TV found. Are you connected to the same Wifi as your TV ?'),
          isThreeLine: true,
        )
      ],
    );
  }
}
