import 'package:web_os/web_os_bindings_api.dart';
import 'package:web_os/web_os_client_api/web_os_client_api.dart';

class WebOsAudio implements WebOsAudioAPI {
  final WebOsBindingsAPI _bindings;

  WebOsAudio(this._bindings);

  @override
  void decreaseVolume() => _bindings.decreaseVolume();
  @override
  void incrementVolume() => _bindings.incrementVolume();

  @override
  void setMute(bool mute) => _bindings.setMute(mute ? 1 : 0);
}
