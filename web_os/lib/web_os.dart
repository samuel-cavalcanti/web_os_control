import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'web_os_bindings_generated.dart';

typedef WebOsLauchApp = LaunchAppFFI;

enum WebOsTvApp {
  youTube(WebOsLauchApp.YouTube),
  netflix(WebOsLauchApp.Netflix),
  amazonPrimeVideo(WebOsLauchApp.AmazonPrimeVideo);

  const WebOsTvApp(this.code);
  final int code;
}

void pressedWebOsTVApp(WebOsTvApp app) => _bindings.launch_app(app.code);
typedef WebOSMotionButtonKey = MotionButtonKeyFFI;

enum MotionKey {
  home(WebOSMotionButtonKey.HOME),
  back(WebOSMotionButtonKey.BACK),
  up(WebOSMotionButtonKey.UP),
  down(WebOSMotionButtonKey.DOWN),
  left(WebOSMotionButtonKey.LEFT),
  right(WebOSMotionButtonKey.RIGHT),
  enter(WebOSMotionButtonKey.ENTER);

  const MotionKey(this.code);
  final int code;
}

void pressedMotionKey(MotionKey key) => _bindings.pressed_button(key.code);

typedef WebOSMidiaPlayerButtonKey = MidiaPlayerButtonFFI;

enum MidiaPlayerKey {
  play(WebOSMidiaPlayerButtonKey.PLAY),
  pause(WebOSMidiaPlayerButtonKey.PAUSE);

  const MidiaPlayerKey(this.code);
  final int code;
}

void pressedMidiaPlayerKey(MidiaPlayerKey key) =>
    _bindings.pressed_midia_player_button(key.code);

/* Volume */

void incrementVolume() => _bindings.increment_volume();

void decreaseVolume() => _bindings.decrease_volume();

void setMute(bool mute) => _bindings.set_mute(mute ? 1 : 0);

void connectToTV(String address, String key) {
  final addressCstr = address.toNativeUtf8().cast<Char>();
  final keyCstr = key.toNativeUtf8().cast<Char>();

  _bindings.connect_to_tv(addressCstr, keyCstr);

  malloc.free(addressCstr);
  malloc.free(keyCstr);
}

void debugMode() => _bindings.debug_mode();

void pointerMoveIt(double dx, double dy, bool drag) =>
    _bindings.pointer_move_it(dx, dy, drag ? 1 : 0);

void pointerScroll(double dx, double dy) => _bindings.pointer_scroll(dx, dy);

void pointerClick() => _bindings.pointer_click();

const String _libName = 'web_os';

/// The dynamic library in which the symbols for [WebOsBindings] can be found.
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dylib].
final WebOsBindings _bindings = WebOsBindings(_dylib);
