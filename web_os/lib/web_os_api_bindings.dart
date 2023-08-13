import 'package:web_os/web_os_bindings_generated.dart';
import 'package:flutter/foundation.dart';

import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'web_os_bindings_api.dart';

class WebOsDynamicLib implements WebOsBindingsAPI {
  WebOsDynamicLib() {
    enable_native_isolate();
  }

  @override
  void incrementChannel(SendPort port) =>
      _bindings.increment_channel(port.nativePort);

  @override
  void decreaseChannel(SendPort port) =>
      _bindings.decrease_channel(port.nativePort);

  @override
  void incrementVolume(SendPort port) =>
      _bindings.increment_volume(port.nativePort);
  @override
  void decreaseVolume(SendPort port) =>
      _bindings.decrease_volume(port.nativePort);

  @override
  void setMute(int mute, SendPort port) =>
      _bindings.set_mute(mute, port.nativePort);

  @override
  void connectToTV(WebOsNetworkInfoFFI info, SendPort port) =>
      _bindings.connect_to_tv(info, port.nativePort);
  @override
  void discoveryBySSDP(SendPort port) =>
      _bindings.discovery_tv(port.nativePort);

  @override
  void loadLastTvInfo(SendPort port) =>
      _bindings.load_last_tv_info(port.nativePort);

  @override
  void turnOn(WebOsNetworkInfoFFI info, SendPort port) =>
      _bindings.turn_on(info, port.nativePort);

  @override
  void click(SendPort port) => _bindings.pointer_click(port.nativePort);
  @override
  void moveIt(double dx, double dy, int drag, SendPort port) =>
      _bindings.pointer_move_it(dx, dy, drag, port.nativePort);
  @override
  void scroll(double scrollDx, double scrollDy, SendPort port) =>
      _bindings.pointer_scroll(scrollDx, scrollDy, port.nativePort);

  @override
  void launchApp(int code, SendPort port) =>
      _bindings.launch_app(code, port.nativePort);

  @override
  void pressedButton(int code, SendPort port) =>
      _bindings.pressed_button(code, port.nativePort);

  @override
  void pressedMediaPlayerButton(int code, SendPort port) =>
      _bindings.pressed_media_player_button(code, port.nativePort);

  @override
  void debugMode() => _bindings.debug_mode();

  @override
  void turnOff(SendPort port) => _bindings.turn_off(port.nativePort);
}

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

void enable_native_isolate() {
  // habilita a utilização do allo-isolate
  store_dart_post_cobject(NativeApi.postCObject);
}
