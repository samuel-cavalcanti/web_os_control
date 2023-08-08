import 'package:flutter/widgets.dart';

import 'webos_app_buttons/webos_app_buttons.dart' as webos_app_buttons;
import 'package:web_os/web_os.dart' as web_os;

import 'volume/volume_widgets.dart' as volume_widgets;

import 'channel/channel_widgets.dart' as channel_widgets;

import 'motion/motion_control_widget.dart';

import 'midia_player_buttons/midia_player_buttons_widgets.dart'
    as midia_player_buttons;

void enableDebug() => web_os.debugMode();

void setMute(bool mute) => web_os.setMute(mute);

void onScroll(double dy) => web_os.pointerScroll(0.0, -dy);

void volumeOnPressed(volume_widgets.Volume v) {
  switch (v) {
    case volume_widgets.Volume.up:
      web_os.incrementVolume();
      break;
    case volume_widgets.Volume.down:
      web_os.decreaseVolume();
      break;
  }
}

void pressedChannel(channel_widgets.ChannelKey key) {
  switch (key) {
    case channel_widgets.ChannelKey.up:
      web_os.incrementChannel();
      break;
    case channel_widgets.ChannelKey.down:
      web_os.decreaseChannel();
      break;
  }
}

void powerOffTV() => web_os.powerOffTV();
Future<bool> powerOnTV() async {
  if (web_os.CACHE_INFO != null) {
    final info = web_os.CACHE_INFO!;
    debugPrint("turing on the TV: $info");
    return web_os.turnOn(info);
  }
  return false;
}

void onSpecialButtonPressed(SpecialKey key) {
  switch (key) {
    case SpecialKey.home:
      web_os.pressedMotionKey(web_os.MotionKey.home);
      break;
    case SpecialKey.back:
      web_os.pressedMotionKey(web_os.MotionKey.back);
      break;
    case SpecialKey.enter:
      web_os.pressedMotionKey(web_os.MotionKey.enter);
      break;
    case SpecialKey.guide:
      web_os.pressedMotionKey(web_os.MotionKey.guide);
      break;
    case SpecialKey.settings:
      web_os.pressedMotionKey(web_os.MotionKey.menu);
      break;
  }
}

void onArrowButtonPressed(ArrowKey key) {
  switch (key) {
    case ArrowKey.up:
      web_os.pressedMotionKey(web_os.MotionKey.up);
      break;
    case ArrowKey.down:
      web_os.pressedMotionKey(web_os.MotionKey.down);
      break;
    case ArrowKey.left:
      web_os.pressedMotionKey(web_os.MotionKey.left);
      break;
    case ArrowKey.right:
      web_os.pressedMotionKey(web_os.MotionKey.right);
      break;
  }
}

void onPressedMediaPlayerButton(midia_player_buttons.MediaPlayerKey key) {
  switch (key) {
    case midia_player_buttons.MediaPlayerKey.play:
      web_os.pressedMediaPlayerKey(web_os.MidiaPlayerKey.play);
      break;
    case midia_player_buttons.MediaPlayerKey.pause:
      web_os.pressedMediaPlayerKey(web_os.MidiaPlayerKey.pause);
      break;
  }
}

void onPressedWebOsApp(webos_app_buttons.AppKey key) {
  switch (key) {
    case webos_app_buttons.AppKey.youtube:
      web_os.pressedWebOsTVApp(web_os.WebOsTvApp.youTube);
      break;
    case webos_app_buttons.AppKey.netflix:
      web_os.pressedWebOsTVApp(web_os.WebOsTvApp.netflix);
      break;
    case webos_app_buttons.AppKey.amazonPrimeVideo:
      web_os.pressedWebOsTVApp(web_os.WebOsTvApp.amazonPrimeVideo);
      break;
  }
}
