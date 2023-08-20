import 'package:web_os_control/controllers/tv_state.dart';

enum Volume { up, down }

abstract interface class WebOsVolumeController {
  Future<TvState> setMute(bool mute);
  Future<TvState> setVolume(Volume v);
}
