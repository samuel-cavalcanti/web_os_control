import 'dart:async';

import 'package:web_os/web_os_bindings_api.dart';
import 'package:web_os/web_os_client_api/web_os_client_api.dart';

import 'utils.dart' as utils;

class WebOsAudio implements WebOsAudioAPI {
  final WebOsBindingsAPI _bindings;

  WebOsAudio(this._bindings);

  @override
  Future<bool> decreaseVolume() {
    final (port, future) = utils.singleBooleanMessage();
    _bindings.decreaseVolume(port);

    return future;
  }

  @override
  Future<bool> incrementVolume() {
    final (port, future) = utils.singleBooleanMessage();
    _bindings.incrementVolume(port);

    return future;
  }

  @override
  Future<bool> setMute(bool mute) {
    final (port, future) = utils.singleBooleanMessage();
    _bindings.setMute(mute ? 1 : 0, port);

    return future;
  }
}
