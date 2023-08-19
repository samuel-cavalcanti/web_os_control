import 'package:web_os/web_os_client_api/web_os_client_api.dart';
import 'package:web_os_control/controllers/tv_state.dart';

abstract interface class WebOsButtonController {

  Future<TvState> pressMediaPlayerKey(MediaPlayerKey key);

  Future<TvState> pressWebOsApp(WebOsTvApp key);

  Future<TvState> pressMotionKey(MotionKey key);
}
