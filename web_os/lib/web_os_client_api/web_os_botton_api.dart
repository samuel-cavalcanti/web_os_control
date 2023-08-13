import '../web_os_bindings_generated.dart';

typedef WebOsLauchApp = LaunchAppFFI;
typedef WebOSMotionButtonKey = MotionButtonKeyFFI;
typedef WebOSMidiaPlayerButtonKey = MediaPlayerButtonFFI;

enum WebOsTvApp {
  youTube(WebOsLauchApp.YouTube),
  netflix(WebOsLauchApp.Netflix),
  amazonPrimeVideo(WebOsLauchApp.AmazonPrimeVideo);

  const WebOsTvApp(this.code);
  final int code;
}

enum MotionKey {
  home(WebOSMotionButtonKey.HOME),
  back(WebOSMotionButtonKey.BACK),
  enter(WebOSMotionButtonKey.ENTER),
  guide(WebOSMotionButtonKey.GUIDE),
  menu(WebOSMotionButtonKey.QMENU),
  up(WebOSMotionButtonKey.UP),
  down(WebOSMotionButtonKey.DOWN),
  left(WebOSMotionButtonKey.LEFT),
  right(WebOSMotionButtonKey.RIGHT);

  const MotionKey(this.code);
  final int code;
}

enum MidiaPlayerKey {
  play(WebOSMidiaPlayerButtonKey.PLAY),
  pause(WebOSMidiaPlayerButtonKey.PAUSE);

  const MidiaPlayerKey(this.code);
  final int code;
}

abstract interface class WebOsButtonAPI {
  Future<bool> pressedMediaPlayerKey(MidiaPlayerKey key);

  Future<bool> pressedMotionKey(MotionKey key);

  Future<bool> pressedWebOsTVApp(WebOsTvApp app);
}
