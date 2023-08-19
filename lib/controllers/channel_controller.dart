import 'package:web_os/web_os_client_api/web_os_client_api.dart';
import 'package:web_os_control/controllers/tv_state.dart';
import 'package:web_os_control/controllers/web_os_channel_controller.dart';

class ChannelController implements WebOsChannelController {
  final WebOsChannelAPI _channelAPI;

  ChannelController(this._channelAPI);

  @override
  Future<TvState> pressedChannel(ChannelKey key) async {
    final bool status;
    switch (key) {
      case ChannelKey.up:
        status = await _channelAPI.incrementChannel();
        break;
      case ChannelKey.down:
        status = await _channelAPI.decreaseChannel();
        break;
    }

    return status ? TvState.connected : TvState.disconect;
  }
}
