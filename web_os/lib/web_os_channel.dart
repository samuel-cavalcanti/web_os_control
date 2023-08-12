import 'package:web_os/web_os_bindings_api.dart';

import 'web_os_client_api/web_os_channel_api.dart';

class WebOsChannel implements WebOsChannelAPI {
  final WebOsBindingsAPI _bindings;

  WebOsChannel(this._bindings);
  @override
  void decreaseChannel() => _bindings.decreaseChannel();
  @override
  void incrementChannel() => _bindings.incrementChannel();
}
