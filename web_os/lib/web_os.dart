import 'package:web_os/web_os_api_bindings.dart';
import 'package:web_os/web_os_audio.dart';
import 'package:web_os/web_os_bindings_api.dart';
import 'package:web_os/web_os_button.dart';
import 'package:web_os/web_os_channel.dart';
import 'package:web_os/web_os_client_api/web_os_client_api.dart';
import 'package:web_os/web_os_network.dart';
import 'package:web_os/web_os_pointer.dart';
import 'package:web_os/web_os_system.dart';

class WebOsClient {
  final WebOsBindingsAPI _bindings;
  late final WebOsNetworkAPI network;
  late final WebOsAudioAPI audio;
  late final WebOsButtonAPI button;
  late final WebOsChannelAPI channel;
  late final WebOsPointerAPI pointer;
  late final WebOsSystemAPI system;

  WebOsClient(this._bindings) {
    network = WebOsNetwork(_bindings);
    audio = WebOsAudio(_bindings);
    button = WebOsButton(_bindings);
    channel = WebOsChannel(_bindings);
    pointer = WebOsPointer(_bindings);
    system = WebOsSystem(_bindings);
  }
}

late final WebOsClient WEB_OS;

void setup() {
  WEB_OS = WebOsClient(WebOsDynamicLib());
}
