import 'package:flutter/material.dart';
import 'package:web_os_control/controllers/web_os_controllers_interface/web_os_button_controller.dart';
import 'package:web_os_control/controllers/web_os_controllers_interface/web_os_channel_controller.dart';
import 'package:web_os_control/controllers/web_os_controllers_interface/web_os_pointer_controller.dart';
import 'package:web_os_control/controllers/web_os_controllers_interface/web_os_system_controller.dart';
import 'package:web_os_control/controllers/web_os_controllers_interface/web_os_volume_controller.dart';
import 'package:web_os_control/web_os_control_routers.dart' as routers;

import 'package:web_os_control/controllers/controllers.dart' as controllers;

import 'motion/motion_control_widget.dart';

import 'channel/channel_widgets.dart' as channel_widgets;

import 'scrollbar/scroll_bar.dart';

import 'volume/volume_widgets.dart' as volume_widgets;

import 'midia_player_buttons/midia_player_buttons_widgets.dart'
    as midia_player_buttons;
import 'webos_app_buttons/webos_app_buttons.dart' as webos_app_buttons;

import 'power/power_button_widget.dart' as power_widget;

class RemoteControlPage extends StatelessWidget {
  const RemoteControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final buttonController = controllers.getController<WebOsButtonController>();
    const flex = 5;
    debugPrint(
        "Size of screen: $size My phone size (360.0, 592.0)"); // My phone size (360.0, 592.0)
    return Scaffold(
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
              Expanded(
                flex: flex,
                child: MotionControlButtons(
                  onTab: buttonController.pressMotionKey,
                ),
              ),
              Expanded(
                flex: flex,
                child: SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      midia_player_buttons.MediaPlayerButtons(
                          onPressed: buttonController.pressMediaPlayerKey),
                      webos_app_buttons
                          .appButtonsList(buttonController.pressWebOsApp)
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

  final volumeController = controllers.getController<WebOsVolumeController>();
  final systemController = controllers.getController<WebOsSystemController>();
  final channelController = controllers.getController<WebOsChannelController>();
  final pointerControoler = controllers.getController<WebOsPointerController>();
  return Row(
    children: [
      const Spacer(),
      Expanded(
        flex: flexButtons,
        child: volume_widgets.VolumeButton(
          volumeOnPressed: volumeController.setVolume,
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
            power_widget.PowerButton(onPressed: (bool power) {
              systemController.turnOff();
              Navigator.of(context).popAndPushNamed(routers.connectToTVPage);
            }),
            volume_widgets.VolumeMute(
              setMute: volumeController.setMute,
            ),
          ],
        ),
      ),
      const Spacer(
        flex: flexSpace - 2,
      ),
      Expanded(
        flex: flexButtons,
        child: channel_widgets.ChannelButton(
          onPressed: channelController.pressedChannel,
        ),
      ),
      Expanded(
        flex: flexSpace + 2,
        child: ScrollBar(onMoveY: pointerControoler.scroll),
      ),
    ],
  );
}
