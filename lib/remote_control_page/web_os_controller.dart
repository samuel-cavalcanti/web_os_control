import 'package:web_os/web_os_client_api/web_os_client_api.dart';

import 'webos_app_buttons/webos_app_buttons.dart' as webos_app_buttons;
import 'package:web_os/web_os.dart' as web_os;

import 'volume/volume_widgets.dart' as volume_widgets;

import 'channel/channel_widgets.dart' as channel_widgets;

import 'motion/motion_control_widget.dart';

import 'midia_player_buttons/midia_player_buttons_widgets.dart'
    as midia_player_buttons;

void setMute(bool mute) => web_os.WEB_OS.audio.setMute(mute);

void onScroll(double dy) => web_os.WEB_OS.pointer.scroll(0.0, -dy);

void volumeOnPressed(volume_widgets.Volume v) {
  switch (v) {
    case volume_widgets.Volume.up:
      web_os.WEB_OS.audio.incrementVolume();
      break;
    case volume_widgets.Volume.down:
      web_os.WEB_OS.audio.decreaseVolume();
      break;
  }
}

void pressedChannel(channel_widgets.ChannelKey key) {
  switch (key) {
    case channel_widgets.ChannelKey.up:
      web_os.WEB_OS.channel.incrementChannel();
      break;
    case channel_widgets.ChannelKey.down:
      web_os.WEB_OS.channel.decreaseChannel();
      break;
  }
}

void powerOffTV() => web_os.WEB_OS.system.powerOff();

final pressedMotionKey = web_os.WEB_OS.button.pressedMotionKey;

void onSpecialButtonPressed(SpecialKey key) {
  switch (key) {
    case SpecialKey.home:
      pressedMotionKey(MotionKey.home);
      break;
    case SpecialKey.back:
      pressedMotionKey(MotionKey.back);
      break;
    case SpecialKey.enter:
      pressedMotionKey(MotionKey.enter);
      break;
    case SpecialKey.guide:
      pressedMotionKey(MotionKey.guide);
      break;
    case SpecialKey.settings:
      pressedMotionKey(MotionKey.menu);
      break;
  }
}

void onArrowButtonPressed(ArrowKey key) {
  switch (key) {
    case ArrowKey.up:
      pressedMotionKey(MotionKey.up);
      break;
    case ArrowKey.down:
      pressedMotionKey(MotionKey.down);
      break;
    case ArrowKey.left:
      pressedMotionKey(MotionKey.left);
      break;
    case ArrowKey.right:
      pressedMotionKey(MotionKey.right);
      break;
  }
}

void onPressedMediaPlayerButton(midia_player_buttons.MediaPlayerKey key) {
  final pressedMediaPlayerKey = web_os.WEB_OS.button.pressedMediaPlayerKey;
  switch (key) {
    case midia_player_buttons.MediaPlayerKey.play:
      pressedMediaPlayerKey(MidiaPlayerKey.play);
      break;
    case midia_player_buttons.MediaPlayerKey.pause:
      pressedMediaPlayerKey(MidiaPlayerKey.pause);
      break;
  }
}

void onPressedWebOsApp(webos_app_buttons.AppKey key) {
  final pressedWebOsTVApp = web_os.WEB_OS.button.pressedWebOsTVApp;
  switch (key) {
    case webos_app_buttons.AppKey.youtube:
      pressedWebOsTVApp(WebOsTvApp.youTube);
      break;
    case webos_app_buttons.AppKey.netflix:
      pressedWebOsTVApp(WebOsTvApp.netflix);
      break;
    case webos_app_buttons.AppKey.amazonPrimeVideo:
      pressedWebOsTVApp(WebOsTvApp.amazonPrimeVideo);
      break;
  }
}
