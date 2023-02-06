import 'package:flutter/material.dart';
import 'volume_controller.dart';

class VolumeView {
  VolumeView({required this.volumeOnPressed});
  final void Function(Volume) volumeOnPressed;

  Widget buildVolumeUp(BuildContext context) => IconButton(
        onPressed: () => volumeOnPressed(Volume.up),
        icon: Icon(
          Icons.add,
          size: 30,
          color: Theme.of(context).colorScheme.surface,
        ),
      );

  Widget buildVolumeMute() => IconButton(
        onPressed: () => volumeOnPressed(Volume.mute),
        icon: const Icon(
          Icons.volume_mute,
          size: 50,
        ),
      );

  Widget buildVolumeDown(BuildContext context) => IconButton(
        onPressed: () => volumeOnPressed(Volume.down),
        icon: Icon(
          Icons.remove,
          size: 30,
          color: Theme.of(context).colorScheme.surface,
        ),
      );
}
