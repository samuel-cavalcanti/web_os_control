import 'package:flutter/material.dart';
import 'package:web_os_control/controllers/remote_control_page_controller.dart';
import 'package:web_os_control/web_os_control_routers.dart' as routers;

import 'motion/motion_control_widget.dart';

import 'channel/channel_widgets.dart' as channel_widgets;

import 'scrollbar/scroll_bar.dart';

import 'volume/volume_widgets.dart' as volume_widgets;

import 'midia_player_buttons/midia_player_buttons_widgets.dart'
    as midia_player_buttons;
import 'webos_app_buttons/webos_app_buttons.dart' as webos_app_buttons;

import 'power/power_button_widget.dart' as power_widget;

import 'remote_control_page_controller.dart';

class RemoteControlPage extends StatelessWidget {
  const RemoteControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = RemoteControlPageController(Navigator.of(context));
    final size = MediaQuery.of(context).size;
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
                child: volumeChannelPowerScrollButtons(context, controller),
              ),
              const Spacer(),
              Expanded(
                flex: flex,
                child: MotionControlButtons(
                  onArrowPressed: controller.onArrowButtonPressed,
                  onSpecialKeyPressed: controller.onSpecialButtonPressed,
                ),
              ),
              Expanded(
                flex: flex,
                child: SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      midia_player_buttons.MediaPlayerButtons(
                          onPressed: controller.onPressedMediaPlayerButton),
                      webos_app_buttons
                          .appButtonsList(controller.onPressedWebOsApp)
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

Widget volumeChannelPowerScrollButtons(
    BuildContext context, RemoteControlPageController controller) {
  const flexButtons = 4;
  const flexSpace = 4;
  return Row(
    children: [
      const Spacer(),
      Expanded(
        flex: flexButtons,
        child: volume_widgets.VolumeButton(
          volumeOnPressed: controller.volumeOnPressed,
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
              controller.powerOffTV();
            }),
            volume_widgets.VolumeMute(
              setMute: controller.setMute,
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
          onPressed: controller.pressedChannel,
        ),
      ),
      Expanded(
        flex: flexSpace + 2,
        child: ScrollBar(onMoveY: controller.onScroll),
      ),
    ],
  );
}
