import 'package:flutter/material.dart';

import '../rounded_container.dart';


class ChannelButton extends StatelessWidget {
  const ChannelButton({super.key, required this.onPressed});
  final void Function(ChannelKey) onPressed;
  @override
  Widget build(BuildContext context) => RoundedContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildChannelUp(context),
            Text(
              "CH",
              style: TextStyle(color: Theme.of(context).colorScheme.surface),
            ),
            buildChannelDown(context)
          ],
        ),
      );

  IconButton buildChannelDown(BuildContext context) {
    return IconButton(
      onPressed: () => onPressed(ChannelKey.down),
      icon: Icon(
        Icons.expand_more,
        size: 30,
        color: Theme.of(context).colorScheme.surface,
      ),
    );
  }

  IconButton buildChannelUp(BuildContext context) {
    return IconButton(
      onPressed: () => onPressed(ChannelKey.up),
      icon: Icon(
        Icons.expand_less,
        size: 30,
        color: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}
