import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'web_os_app_icons.dart';
import 'package:web_os/web_os.dart' as web_os;

class NetflixButton extends StatelessWidget {
  const NetflixButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => web_os.pressedWebOsTVApp(web_os.WebOsTvApp.netflix),
      child: const SizedBox(
          width: 100,
          height: 35,
          child: Icon(
            size: 15,
            netflix,
            color: Colors.red,
          )),
    );
  }
}

class PrimeVideoButton extends StatelessWidget {
  const PrimeVideoButton({super.key});

  @override
  Widget build(BuildContext context) {
    const amazonprimevideoColor = 0xFF00a8e1;
    return ElevatedButton(
      onPressed: () =>
          web_os.pressedWebOsTVApp(web_os.WebOsTvApp.amazonPrimeVideo),
      child: const SizedBox(
          width: 100,
          height: 35,
          child: Icon(
            size: 15,
            amazonprimevideo,
            color: Color(amazonprimevideoColor),
          )),
    );
  }
}

class YoutubeButton extends StatelessWidget {
  const YoutubeButton({super.key});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => web_os.pressedWebOsTVApp(web_os.WebOsTvApp.youTube),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const FaIcon(
            FontAwesomeIcons.youtube,
            color: Colors.redAccent,
            size: 10,
          ),
          Text('YouTube',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .merge(const TextStyle(fontWeight: FontWeight.w700)))
        ],
      ),
    );
  }
}
