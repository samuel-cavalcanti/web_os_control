import 'package:web_os/web_os_bindings_api.dart';
import 'package:web_os/web_os_client_api/web_os_client_api.dart';
import 'utils.dart' as utils;

class WebOsButton implements WebOsButtonAPI {
  final WebOsBindingsAPI _bindings;

  WebOsButton(this._bindings);

  @override
  Future<bool> pressedMediaPlayerKey(MediaPlayerKey key) {
    final (port, future) = utils.singleBooleanMessage();
    _bindings.pressedMediaPlayerButton(key.code, port);

    return future;
  }

  @override
  Future<bool> pressedMotionKey(MotionKey key) {
    final (port, future) = utils.singleBooleanMessage();
    _bindings.pressedButton(key.code, port);

    return future;
  }

  @override
  Future<bool> pressedWebOsTVApp(WebOsTvApp app) {
    final (port, future) = utils.singleBooleanMessage();

    _bindings.launchApp(app.code, port);

    return future;
  }
}
