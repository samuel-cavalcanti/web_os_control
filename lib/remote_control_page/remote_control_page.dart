import 'package:flutter/material.dart';
import 'package:web_os_control/web_os_control_routers.dart' as routers;

import 'motion/motion_control_widget.dart';

import 'channel/channel_widgets.dart' as channel_widgets;

import 'scrollbar/scroll_bar.dart';

import 'volume/volume_widgets.dart' as volume_widgets;

import 'midia_player_buttons/midia_player_buttons_widgets.dart'
    as midia_player_buttons;
import 'webos_app_buttons/webos_app_buttons.dart' as webos_app_buttons;

import 'power/power_button_widget.dart' as power_widget;

import 'web_os_controller.dart' as web_os_controller;

class RemoteControlPage extends StatelessWidget {
  const RemoteControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const flex = 5;
    debugPrint(
        "Size of screen: $size My phone size (360.0, 592.0)"); // My phone size (360.0, 592.0)
    return Scaffold(
      //bottomNavigationBar: BottomNavigationBar(items: const [
      //  BottomNavigationBarItem(icon: Icon(Icons.onetwothree), label: ''),
      //  BottomNavigationBarItem(icon: Icon(Icons.control_camera), label: ''),
      //  BottomNavigationBarItem(icon: Icon(Icons.gesture), label: ''),
      //]),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Spacer(
                flex: 2,
              ),
              Expanded(
                flex: flex,
                child: volumeChannelPowerScrollButtons(context),
              ),
              const Spacer(),
              const Expanded(
                flex: flex,
                child: MotionControlButtons(
                  onArrowPressed: web_os_controller.onArrowButtonPressed,
                  onSpecialKeyPressed: web_os_controller.onSpecialButtonPressed,
                ),
              ),
              Expanded(
                flex: flex,
                child: SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const midia_player_buttons.MediaPlayerButtons(
                          onPressed:
                              web_os_controller.onPressedMediaPlayerButton),
                      webos_app_buttons
                          .appButtonsList(web_os_controller.onPressedWebOsApp)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget volumeChannelPowerScrollButtons(BuildContext context) {
  const flexButtons = 4;
  const flexSpace = 4;
  return Row(
    children: [
      const Spacer(),
      const Expanded(
        flex: flexButtons,
        child: volume_widgets.VolumeButton(
          volumeOnPressed: web_os_controller.volumeOnPressed,
        ),
      ),
      const Spacer(
        flex: flexSpace - 2,
      ),
      Expanded(
        flex: flexButtons,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            power_widget.PowerButton(onPressed: (bool power) async {
              Navigator.of(context).popAndPushNamed(routers.connectToTVPage);
              web_os_controller.powerOffTV();
            }),
            const volume_widgets.VolumeMute(
              setMute: web_os_controller.setMute,
            ),
          ],
        ),
      ),
      const Spacer(
        flex: flexSpace - 2,
      ),
      const Expanded(
        flex: flexButtons,
        child: channel_widgets.ChannelButton(
          onPressed: web_os_controller.pressedChannel,
        ),
      ),
      const Expanded(
        flex: flexSpace + 2,
        child: ScrollBar(onMoveY: web_os_controller.onScroll),
      ),
    ],
  );
}
