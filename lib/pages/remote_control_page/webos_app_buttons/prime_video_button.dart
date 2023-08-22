import 'package:flutter/material.dart';

import 'web_os_app_icons.dart';

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
