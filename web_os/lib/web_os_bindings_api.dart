import 'package:web_os/web_os_bindings_generated.dart';
import 'dart:isolate';

abstract interface class WebOsBindingsAPI {
  /// Look [MotionButtonKeyFFI] in [../web_os_bindings_generated.dart]
  void pressedButton(int code);

  /// Look  [LaunchAppFFI] in [../web_os_bindings_generated.dart]
  void launchApp(int code);

  /// Look  [MediaPlayerButtonFFI] in [../web_os_bindings_generated.dart]
  void pressedMediaPlayerButton(int code);

  // try to use Wake on Lan to turn on the TV
  void turnOn(WebOsNetworkInfoFFI info, SendPort port);

  void connectToTV(WebOsNetworkInfoFFI info, SendPort port);

  /// return a List<String> a where:
  /// a[0]  is the ip
  /// a[1]  is the name
  /// a[2]  is the mac address
  void loadLastTvInfo(SendPort port);

  /// try to Discovery the TV using SSDP Search
  /// the TV must be on the be found
  void discoveryBySSDP(SendPort port);

  // move the Tv red pointer
  void moveIt(double dx, double dy, int drag);
  void scroll(double scrollDx, double scrollDy);
  void click();

  //  volume++
  void incrementVolume();

  // volume--
  void decreaseVolume();

  void setMute(int mute);

  void incrementChannel();

  void decreaseChannel();

  /// Enable logs
  void debugMode();
}
