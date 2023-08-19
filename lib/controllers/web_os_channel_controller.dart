import 'package:web_os_control/controllers/tv_state.dart';

enum ChannelKey { up, down }

abstract interface class WebOsChannelController {
  Future<TvState> pressedChannel(ChannelKey key);
}
