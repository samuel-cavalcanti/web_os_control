import 'package:flutter/material.dart';
import 'package:web_os_control/controllers/web_os_controllers_interface/web_os_volume_controller.dart';
import '../rounded_container.dart';


class VolumeMuteButton extends StatefulWidget {
  const VolumeMuteButton({
    super.key,
    required this.setMute,
  });

  final void Function(bool) setMute;
  @override
  State<StatefulWidget> createState() => _VolumeMuteButtonState();
}

class _VolumeMuteButtonState extends State<VolumeMuteButton> {
  bool _mute = false;
  final notMutedIcon = const Icon(
    Icons.volume_mute,
    size: 50,
  );

  final mutedIcon = const Icon(
    Icons.volume_off,
    size: 50,
  );

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: () {
          setState(() {
            _mute = !_mute;
            widget.setMute(_mute);
          });
        },
        icon: _mute ? mutedIcon : notMutedIcon,
      );
}

class VolumeButton extends StatelessWidget {
  const VolumeButton({super.key, required this.volumeOnPressed});
  final void Function(Volume) volumeOnPressed;
  @override
  Widget build(BuildContext context) => RoundedContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildVolumeUp(context),
            Text(
              "VOL",
              style: TextStyle(color: Theme.of(context).colorScheme.surface),
            ),
            buildVolumeDown(context)
          ],
        ),
      );

  Widget buildVolumeUp(BuildContext context) => IconButton(
        onPressed: () => volumeOnPressed(Volume.up),
        icon: Icon(
          Icons.add,
          size: 30,
          color: Theme.of(context).colorScheme.surface,
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
