import 'package:flutter/material.dart';
import 'web_os_app_icons.dart';

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
