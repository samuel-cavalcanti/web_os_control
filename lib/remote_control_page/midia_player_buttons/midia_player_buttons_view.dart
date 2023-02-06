import 'package:flutter/material.dart';
import 'package:web_os/web_os.dart' as web_os;

Widget playButton() => ElevatedButton(
      onPressed: () => web_os.pressedMidiaPlayerKey(web_os.MidiaPlayerKey.play),
      child: const Icon(Icons.play_arrow),
    );

Widget pauseButton() => ElevatedButton(
      onPressed: () =>
          web_os.pressedMidiaPlayerKey(web_os.MidiaPlayerKey.pause),
      child: const Icon(Icons.pause),
    );
