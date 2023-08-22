import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vector_math/vector_math_64.dart' as math;

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
            width: 16,
            height: 16,
            transform: Matrix4.translation(math.Vector3(-6, 0.0, 0)),
            child: Stack(alignment: Alignment.center, children: [
              Container(color: Colors.white, width: 9, height: 9),
              const FaIcon(
                FontAwesomeIcons.youtube,
                color: Colors.redAccent,
                size: 35 / 2,
              ),
            ]),
          ),
          Text('YouTube',
              style: Theme.of(context).textTheme.bodySmall!.merge(
                  const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.0)))
        ],
      ),
    );
  }
}
