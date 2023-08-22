import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web_os/web_os_client_api/web_os_client_api.dart';
import 'package:web_os_control/controllers/tv_state.dart';
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

import 'volume/volume_widgets.dart';

import 'midia_player_buttons/midia_player_buttons_widgets.dart';
import 'webos_app_buttons/webos_app_buttons.dart';

import 'power/power_button_widget.dart';

class RemoteControlPage extends StatefulWidget {
  const RemoteControlPage({super.key});

  @override
  State<RemoteControlPage> createState() => _RemoteControlPageState();
}

class _RemoteControlPageState extends State<RemoteControlPage> {
  void _backPage(Future<TvState> webOsFuture) {
    webOsFuture.then((TvState state) {
      if (state == TvState.disconect) {
        Navigator.of(context).popAndPushNamed(routers.connectToTVPage);
      }
    });
  }

  void _motionOnTab(MotionKey key) {
    final buttonController = controllers.getController<WebOsButtonController>();
    final future = buttonController.pressMotionKey(key);
    _backPage(future);
  }

  void _midiaPlayerOnPressed(MediaPlayerKey key) {
    final controller = controllers.getController<WebOsButtonController>();
    final future = controller.pressMediaPlayerKey(key);
    _backPage(future);
  }

  void _webOsAppOnPressed(WebOsTvApp app) {
    final controller = controllers.getController<WebOsButtonController>();
    final future = controller.pressWebOsApp(app);

    _backPage(future);
  }

  void _volumeOnPressed(Volume volume) {
    final volumeController = controllers.getController<WebOsVolumeController>();
    final future = volumeController.setVolume(volume);

    _backPage(future);
  }

  void _setMute(bool mute) {
    final volumeController = controllers.getController<WebOsVolumeController>();
    final future = volumeController.setMute(mute);

    _backPage(future);
  }

  void _powerButtonPressed(bool power) {
    final systemController = controllers.getController<WebOsSystemController>();
    final future = systemController.turnOff();

    _backPage(future);
  }

  void _pressedChannel(ChannelKey key) {
    final channelController =
        controllers.getController<WebOsChannelController>();

    final future = channelController.pressedChannel(key);

    _backPage(future);
  }

  void _onMoveY(double dy) {
    final pointerControoler =
        controllers.getController<WebOsPointerController>();
    final future = pointerControoler.scroll(dy);

    _backPage(future);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const flex = 5;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    debugPrint(
        "Size of screen: $size My phone size (360.0, 592.0)"); // My phone size (360.0, 592.0)
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Spacer(
              flex: 1,
            ),
            Expanded(
              flex: flex,
              child: volumeChannelPowerScrollButtons(context),
            ),
            const Spacer(),
            Expanded(
              flex: flex,
              child: MotionControlButtons(
                onTab: _motionOnTab,
              ),
            ),
            Expanded(
              flex: flex,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MediaPlayerButtons(
                    onPressed: _midiaPlayerOnPressed,
                  ),
                  WebOsAppsButtonListView(onPressed: _webOsAppOnPressed)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget volumeChannelPowerScrollButtons(BuildContext context) {
    const flexButtons = 4;
    const flexSpace = 4;

    return Row(
      children: [
        const Spacer(),
        Expanded(
          flex: flexButtons,
          child: VolumeButton(
            volumeOnPressed: _volumeOnPressed,
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
              PowerButton(onPressed: _powerButtonPressed),
              VolumeMuteButton(setMute: _setMute),
            ],
          ),
        ),
        const Spacer(
          flex: flexSpace - 2,
        ),
        Expanded(
          flex: flexButtons,
          child: channel_widgets.ChannelButton(
            onPressed: _pressedChannel,
          ),
        ),
        Expanded(
          flex: flexSpace + 2,
          child: ScrollBar(onMoveY: _onMoveY),
        ),
      ],
    );
  }
}
