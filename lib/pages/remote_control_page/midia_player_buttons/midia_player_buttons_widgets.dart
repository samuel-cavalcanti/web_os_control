import 'package:flutter/material.dart';
import 'package:web_os/web_os_client_api/web_os_botton_api.dart';

import 'pause_button.dart';
import 'play_button.dart';

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
              child: PlayButton(
                onPressed: onPressed,
              ),
            ),
            const Spacer(),
            Expanded(
              flex: 10,
              child: PauseButton(
                onPressed: onPressed,
              ),
            ),
          ],
        ),
      );
}
