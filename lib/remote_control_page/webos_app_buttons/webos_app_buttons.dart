import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'web_os_app_icons.dart';
import 'package:vector_math/vector_math_64.dart' as math;

enum AppKey { youtube, netflix, amazonPrimeVideo }

Widget appButtonsList(void Function(AppKey) onPressed) => Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
              flex: 7,
              child: PrimeVideoButton(
                onPressed: () => onPressed(AppKey.amazonPrimeVideo),
              )),
          const Spacer(),
          Expanded(
              flex: 7,
              child: YoutubeButton(
                onPressed: () => onPressed(AppKey.youtube),
              )),
          const Spacer(),
          Expanded(
              flex: 7,
              child: NetflixButton(
                onPressed: () => onPressed(AppKey.netflix),
              )),
        ],
      ),
    );

class NetflixButton extends StatelessWidget {
  const NetflixButton({super.key, required this.onPressed});
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
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
  const PrimeVideoButton({super.key, required this.onPressed});

  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    const amazonprimevideoColor = 0xFF00a8e1;
    return ElevatedButton(
      onPressed: onPressed,
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
  const YoutubeButton({super.key, required this.onPressed});

  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            transform: Matrix4.translation(math.Vector3(-5, 0.0, 0)),
            child: Stack(alignment: Alignment.center, children: [
              Container(color: Colors.white, width: 9, height: 9),
              const FaIcon(
                FontAwesomeIcons.youtube,
                color: Colors.redAccent,
                size: 16,
              ),
            ]),
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
