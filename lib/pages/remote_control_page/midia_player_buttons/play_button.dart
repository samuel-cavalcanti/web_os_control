import 'package:flutter/material.dart';
import 'package:web_os/web_os_client_api/web_os_client_api.dart';

class PlayButton extends StatelessWidget {
  const PlayButton({super.key, required this.onPressed});
  final void Function(MediaPlayerKey) onPressed;

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: () => onPressed(MediaPlayerKey.play),
        child: Icon(
          Icons.play_arrow,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      );
}
