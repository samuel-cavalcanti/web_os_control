import 'package:flutter/material.dart';

Widget powerButton(void Function() onPressed) {
  return IconButton(
    onPressed: onPressed,
    icon: const Icon(
      Icons.power_settings_new,
      size: 50,
    ),
  );
}

class PowerButton extends StatefulWidget {
  final  Function(bool power) onPressed;
  const PowerButton({super.key, required this.onPressed});

  @override
  State<PowerButton> createState() => _PowerButtonState();
}

class _PowerButtonState extends State<PowerButton> {
  bool power = true;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          power = !power;
          widget.onPressed(power);
        });
      },
      icon: Icon(
        Icons.power_settings_new,
        size: 50,
        color: power ? Colors.red : null,
      ),
    );
  }
}
