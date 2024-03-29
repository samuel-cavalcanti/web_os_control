import 'package:flutter/material.dart';


class PowerButton extends StatefulWidget {
  final Function(bool power) onPressed;
  const PowerButton({super.key, required this.onPressed});

  @override
  State<PowerButton> createState() => _PowerButtonState();
}

class _PowerButtonState extends State<PowerButton> {
  bool power = true;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 50,
      onPressed: () {
        setState(() {
          power = !power;
          widget.onPressed(power);
        });
      },
      icon: Icon(
        Icons.power_settings_new,
        color: power ? Colors.red : null,
      ),
    );
  }
}
