import 'package:web_os/web_os_client_api/web_os_client_api.dart';
import 'package:web_os_control/controllers/tv_state.dart';
import 'package:web_os_control/controllers/web_os_volume_controller.dart';

class VolumeController implements WebOsVolumeController {
  final WebOsAudioAPI _audioAPI;

  VolumeController(this._audioAPI);

  @override
  Future<TvState> setMute(bool mute) async {
    final status = await _audioAPI.setMute(mute);

    return status ? TvState.connected : TvState.disconect;
  }

  @override
  Future<TvState> setVolume(Volume v) async {
    final bool status;
    switch (v) {
      case Volume.up:
        status = await _audioAPI.incrementVolume();
        break;
      case Volume.down:
        status = await _audioAPI.decreaseVolume();
        break;
    }

    return status ? TvState.connected : TvState.disconect;
  }
}
