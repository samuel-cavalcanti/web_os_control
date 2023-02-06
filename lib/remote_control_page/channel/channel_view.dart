import 'package:flutter/material.dart';

class ChannelView {
  IconButton buildChannelDown(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: Icon(
        Icons.expand_more,
        size: 30,
        color: Theme.of(context).colorScheme.surface,
      ),
    );
  }

  IconButton buildChannelUp(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: Icon(
        Icons.expand_less,
        size: 30,
        color: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}
