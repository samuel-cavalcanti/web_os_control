import 'package:flutter/material.dart';
import 'package:web_os_control/remote_control_page/volume/volume_controller.dart';
import 'channel/channel_view.dart';
import 'rounded_container.dart';
import 'volume/volume_view.dart';
import 'motion/motion_view.dart' as motion_view;
import 'midia_player_buttons/midia_player_buttons_view.dart'
    as midia_player_buttons;
import 'webos_app_buttons/webos_app_buttons.dart';

Widget midiaPlayerButtons() => Row(
      children: [
        Expanded(
          flex: 10,
          child: midia_player_buttons.playButton(),
        ),
        const Spacer(),
        Expanded(
          flex: 10,
          child: midia_player_buttons.pauseButton(),
        ),
      ],
    );

Widget motionControlButtons() => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              motion_view.buildHomeButton(),
              motion_view.buildBackButton(),
            ],
          ),
        ),
        Expanded(flex: 3, child: MotionControl()),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.settings,
                  size: 29,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.list,
                  size: 29,
                ),
              ),
            ],
          ),
        )
      ],
    );

Widget mouseRegion(BuildContext context) {
  final secondaryColor = Theme.of(context).colorScheme.secondary;

  return Row(
    children: [
      Expanded(
        flex: 15,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
            ),
            const Icon(
              Icons.near_me,
            )
          ],
        ),
      ),
      const Spacer(),
      Expanded(
          child: Container(
        decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(8))),
      )),
    ],
  );
}

Widget videoButtoms() => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Expanded(flex: 7, child: PrimeVideoButton()),
          Spacer(),
          Expanded(flex: 7, child: YoutubeButton()),
          Spacer(),
          Expanded(flex: 7, child: NetflixButton()),
        ],
      ),
    );

class MotionControl extends StatelessWidget {
  const MotionControl({super.key});

  @override
  Widget build(BuildContext context) {
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    return Align(
      alignment: Alignment.center,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
            decoration: BoxDecoration(
              color: secondaryColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    motion_view.buildMoveUp(context),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        motion_view.buildMoveLeft(context),
                        motion_view.buildEnter(context),
                        motion_view.buildMoveRight(context),
                      ],
                    ),
                    motion_view.buildMoveDown(context),
                  ]),
            )),
      ),
    );
  }
}

class RemoteControlPage extends StatelessWidget {
  const RemoteControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const flex = 4;
    debugPrint(
        "Size of screen: $size My phone size (360.0, 592.0)"); // My phone size (360.0, 592.0)
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(icon: Icon(Icons.onetwothree), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.control_camera), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.gesture), label: ''),
      ]),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Spacer(),
              Expanded(
                flex: flex,
                child: Upper(),
              ),
              const Spacer(),
              Expanded(
                flex: flex,
                child: motionControlButtons(),
              ),
              Expanded(
                  flex: flex,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [midiaPlayerButtons(), videoButtoms()],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class Upper extends StatelessWidget {
  late final VolumeView _volumeView;
  late final ChannelView _channelView;
  Upper({super.key}) {
    final controller = VolumeController();
    _volumeView = VolumeView(volumeOnPressed: controller.volumeOnPressed);
    _channelView = ChannelView();
  }

  @override
  Widget build(BuildContext context) {
    const flexButtons = 4;
    const flexSpace = 4;
    return Row(
      children: [
        const Spacer(),
        Expanded(
          flex: flexButtons,
          child: plusMinusVolumeButton(context),
        ),
        const Spacer(
          flex: flexSpace - 2,
        ),
        Expanded(
          flex: flexButtons,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              powerButton(),
              _volumeView.buildVolumeMute(),
            ],
          ),
        ),
        const Spacer(
          flex: flexSpace - 2,
        ),
        Expanded(
          flex: flexButtons,
          child: upDownChannelButton(context),
        ),
        Expanded(
          flex: flexSpace + 2,
          child: scrollButton(context),
        ),
      ],
    );
  }

  Widget upDownChannelButton(BuildContext context) => RoundedContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _channelView.buildChannelUp(context),
            Text(
              "CH",
              style: TextStyle(color: Theme.of(context).colorScheme.surface),
            ),
            _channelView.buildChannelDown(context)
          ],
        ),
      );

  Widget plusMinusVolumeButton(BuildContext context) => RoundedContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _volumeView.buildVolumeUp(context),
            Text(
              "VOL",
              style: TextStyle(color: Theme.of(context).colorScheme.surface),
            ),
            _volumeView.buildVolumeDown(context)
          ],
        ),
      );

  Align scrollButton(BuildContext context) => Align(
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(8)),
          width: 20,
          height: double.infinity,
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  shape: BoxShape.circle),
            ),
          ),
        ),
      );

  IconButton powerButton() => IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.power_settings_new,
          size: 50,
        ),
      );
}
