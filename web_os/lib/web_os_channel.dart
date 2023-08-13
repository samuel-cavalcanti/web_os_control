import 'package:web_os/web_os_bindings_api.dart';

import 'web_os_client_api/web_os_channel_api.dart';

import 'utils.dart' as utils;

class WebOsChannel implements WebOsChannelAPI {
  final WebOsBindingsAPI _bindings;

  WebOsChannel(this._bindings);
  @override
  Future<bool> decreaseChannel() {
    final (port, future) = utils.singleBooleanMessage();

    _bindings.decreaseChannel(port);

    return future;
  }

  @override
  Future<bool> incrementChannel() {
    final (port, future) = utils.singleBooleanMessage();

    _bindings.incrementChannel(port);
    
    return future;
  }
}
