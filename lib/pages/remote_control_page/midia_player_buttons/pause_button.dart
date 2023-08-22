import 'package:flutter/material.dart';
import 'package:web_os/web_os_client_api/web_os_client_api.dart';

class PauseButton extends StatelessWidget {
  const PauseButton({super.key, required this.onPressed});

  final void Function(MediaPlayerKey) onPressed;
  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: () => onPressed(MediaPlayerKey.pause),
        child: Icon(
          Icons.pause,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      );
}
