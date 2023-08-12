import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'web_os_bindings_generated.dart';
import 'web_os_api_bindings.dart';

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

void pressedWebOsTVApp(WebOsTvApp app) => _bindings.launch_app(app.code);

enum MotionKey {
  home(WebOSMotionButtonKey.HOME), back(WebOSMotionButtonKey.BACK),
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

void pressedMotionKey(MotionKey key) => _bindings.pressed_button(key.code);


enum MidiaPlayerKey {
  play(WebOSMidiaPlayerButtonKey.PLAY),
  pause(WebOSMidiaPlayerButtonKey.PAUSE);

  const MidiaPlayerKey(this.code);
  final int code;
}

void pressedMediaPlayerKey(MidiaPlayerKey key) =>
    _bindings.pressed_media_player_button(key.code);

/* Volume */

void incrementVolume() => _bindings.increment_volume();

void decreaseVolume() => _bindings.decrease_volume();

void setMute(bool mute) => _bindings.set_mute(mute ? 1 : 0);

void incrementChannel() => _bindings.increment_channel();

void decreaseChannel() => _bindings.decrease_channel();

class WebOsNetworkInfo {
  final String ip;
  final String mac;
  final String name;

  const WebOsNetworkInfo(
      {required this.ip, required this.mac, required this.name});

  @override
  String toString() {
    return '''WebOsNetworkInfo{
        name:$name,
        mac:$mac,
        ip:$ip,
    }
        ''';
  }
}

Pointer<WebOsNetworkInfoFFI> _allocateInfoFFI(WebOsNetworkInfo info) {
  final infoPointer = malloc.allocate<WebOsNetworkInfoFFI>(1);

  infoPointer.ref.mac = info.mac.toNativeUtf8().cast<Char>();
  infoPointer.ref.ip = info.ip.toNativeUtf8().cast<Char>();
  infoPointer.ref.name = info.name.toNativeUtf8().cast<Char>();

  return infoPointer;
}

// info -> Pointer<Info>
// complete + _singleMessagea --> future<boo>

// info --> Future<a> --> Future<b>


Future<bool> turnOn(WebOsNetworkInfo info) {

  final infoPointer = _allocateInfoFFI(info);
  final completer = Completer<bool>();
  final sendPort = _singleMessage(completer);

  _bindings.turn_on(infoPointer.ref, sendPort.nativePort);
  final future = completer.future;
  return future;
}

Future<bool> connectToTV(WebOsNetworkInfo info) {
  final completer = Completer<bool>();
  final sendPort = _singleMessage(completer);

  final infoPointer = _allocateInfoFFI(info);
  _bindings.connect_to_tv(infoPointer.ref, sendPort.nativePort);
  final future = completer.future;

  return future;
}

Future<WebOsNetworkInfo?> loadLastTvInfo() {
  final completer = Completer<List<dynamic>>();
  final sendPort = _singleMessage(completer);
  _bindings.load_last_tv_info(sendPort.nativePort);

  future() async {
    final info = await completer.future;

    if (info.runtimeType == List) {
      return WebOsNetworkInfo(ip: info[0], name: info[1], mac: info[2]);
    }

    return null;
  }

  return future();
}



Future<List<WebOsNetworkInfo>> discoveryTv() async {
  debugPrint("Discovery");

  final completer = Completer<List<dynamic>>();

  final sendPort = _singleMessage(completer);
  _bindings.discovery_tv(sendPort.nativePort);

  final data = await completer.future;
  final infos = data
      .map((info) => WebOsNetworkInfo(ip: info[0], name: info[1], mac: info[2]))
      .toList(growable: false);

  debugPrint("completed $data");

  return infos;
}

/// Cria uma porta pelo qual a Main Isolate possa resceber uma mensagem,
/// ao receber a primeira mensagem,a porta se fecha.
SendPort _singleMessage<T>(Completer<T> comp) {
  final recv = ReceivePort();

  onData(data) {
    recv.close();
    debugPrint("Type of data: ${data.runtimeType}, data $data");
    try {
      comp.complete(data as T);
    } catch (error, stack) {
      comp.completeError(error, stack);
    }
  }

  recv.listen(onData);

  return recv.sendPort;
}

void powerOffTV() => _bindings.turn_off();

void debugMode() {
  debugPrint('Enable debug');
  _bindings.debug_mode();
}

void pointerMoveIt(double dx, double dy, bool drag) =>
    _bindings.pointer_move_it(dx, dy, drag ? 1 : 0);

void pointerScroll(double dx, double dy) => _bindings.pointer_scroll(dx, dy);

void pointerClick() => _bindings.pointer_click();

const String _libName = 'web_os';

/// The dynamic library in which the symbols for [WebOsBindings] can be found.
DynamicLibrary openLib() {
  debugPrint('loading lib: $_libName');
  final lib = _dylib();
  debugPrint('loaded lib: $_libName');
  return lib;
}

DynamicLibrary _dylib() {
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
}

/// The bindings to the native functions in [_dylib].
final WebOsBindings _bindings = WebOsBindings(openLib());

/// Binding to `allo-isolate` crate
void store_dart_post_cobject(
  Pointer<NativeFunction<Int8 Function(Int64, Pointer<Dart_CObject>)>> ptr,
) {
  _store_dart_post_cobject(ptr);
}

final _store_dart_post_cobject_Dart _store_dart_post_cobject = _dylib()
    .lookupFunction<_store_dart_post_cobject_C, _store_dart_post_cobject_Dart>(
        'store_dart_post_cobject');

typedef _store_dart_post_cobject_C = Void Function(
  Pointer<NativeFunction<Int8 Function(Int64, Pointer<Dart_CObject>)>> ptr,
);
typedef _store_dart_post_cobject_Dart = void Function(
  Pointer<NativeFunction<Int8 Function(Int64, Pointer<Dart_CObject>)>> ptr,
);

void setup() {
  // habilita a utilização do allo-isolate
  store_dart_post_cobject(NativeApi.postCObject);
}
