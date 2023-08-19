import 'package:flutter/material.dart';
import 'package:web_os/web_os_client_api/web_os_botton_api.dart';

class MediaPlayerButtons extends StatelessWidget {
  const MediaPlayerButtons({super.key, required this.onPressed});
  final void Function(MediaPlayerKey) onPressed;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 10,
              child: playButton(context),
            ),
            const Spacer(),
            Expanded(
              flex: 10,
              child: pauseButton(context),
            ),
          ],
        ),
      );

  Widget playButton(BuildContext context) => ElevatedButton(
        onPressed: () => onPressed(MediaPlayerKey.play),
        child: Icon(
          Icons.play_arrow,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      );

  Widget pauseButton(BuildContext context) => ElevatedButton(
        onPressed: () => onPressed(MediaPlayerKey.pause),
        child: Icon(
          Icons.pause,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      );
}
