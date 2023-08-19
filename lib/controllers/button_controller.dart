import 'package:web_os/web_os_client_api/web_os_botton_api.dart';
import 'package:web_os_control/controllers/tv_state.dart';
import 'package:web_os_control/controllers/web_os_button_controller.dart';

class ButtonController implements WebOsButtonController {
  final WebOsButtonAPI _buttonAPI;

  ButtonController(this._buttonAPI);

  @override
  Future<TvState> pressMediaPlayerKey(MediaPlayerKey key) =>
      _buttonAPI.pressedMediaPlayerKey(key).toTVState();

  @override
  Future<TvState> pressMotionKey(MotionKey key) =>
      _buttonAPI.pressedMotionKey(key).toTVState();

  @override
  Future<TvState> pressWebOsApp(WebOsTvApp key) =>
      _buttonAPI.pressedWebOsTVApp(key).toTVState();
}
