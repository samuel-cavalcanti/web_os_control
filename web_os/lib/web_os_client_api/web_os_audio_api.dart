abstract interface class WebOsAudioAPI {
  Future<bool> incrementVolume();

  Future<bool> decreaseVolume();

  Future<bool> setMute(bool mute);
}
