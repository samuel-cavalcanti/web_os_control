import 'package:flutter/material.dart';
import 'package:web_os/web_os_client_api/web_os_client_api.dart';
import 'netflix_button.dart';
import 'prime_video_button.dart';
import 'youtube_button.dart';

class WebOsAppsButtonListView extends StatelessWidget {
  const WebOsAppsButtonListView({super.key, required this.onPressed});
  final void Function(WebOsTvApp) onPressed;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
                flex: 7,
                child: PrimeVideoButton(
                  onPressed: () => onPressed(WebOsTvApp.amazonPrimeVideo),
                )),
            const Spacer(),
            Expanded(
                flex: 7,
                child: YoutubeButton(
                  onPressed: () => onPressed(WebOsTvApp.youTube),
                )),
            const Spacer(),
            Expanded(
                flex: 7,
                child: NetflixButton(
                  onPressed: () => onPressed(WebOsTvApp.netflix),
                )),
          ],
        ),
      );
}
