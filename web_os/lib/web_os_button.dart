import 'package:web_os/web_os_bindings_api.dart';
import 'package:web_os/web_os_client_api/web_os_client_api.dart';

class WebOsButton implements WebOsButtonAPI {
  final WebOsBindingsAPI _bindings;

  WebOsButton(this._bindings);

  @override
  void pressedMediaPlayerKey(MidiaPlayerKey key) =>
      _bindings.pressedMediaPlayerButton(key.code);

  @override
  void pressedMotionKey(MotionKey key) => _bindings.pressedButton(key.code);

  @override
  void pressedWebOsTVApp(WebOsTvApp app) => _bindings.launchApp(app.code);
}
