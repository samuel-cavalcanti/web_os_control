import 'package:flutter/foundation.dart';
import 'package:web_os/web_os.dart' as web_os;

enum Volume { up, down, mute }

class VolumeController {
  bool _mute = false;
  void volumeOnPressed(Volume v) {
    debugPrint("Volume: $v");

    switch (v) {
      case Volume.up:
        web_os.incrementVolume();
        break;

      case Volume.down:
        web_os.decreaseVolume();
        break;
      case Volume.mute:
        _mute = !_mute;

        web_os.setMute(_mute);
        break;
    }
  }
}
