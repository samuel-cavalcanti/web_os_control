import 'package:flutter/material.dart';

enum MediaPlayerKey { play, pause }

class MediaPlayerButtons extends StatelessWidget {
  const MediaPlayerButtons({super.key, required this.onPressed});
  final void Function(MediaPlayerKey) onPressed;
  @override
  Widget build(BuildContext context) => Row(
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
