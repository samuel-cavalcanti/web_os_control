import 'package:web_os/web_os_bindings_api.dart';
import 'package:web_os/web_os_client_api/web_os_client_api.dart';
import 'utils.dart' as utils;

class WebOsSystem implements WebOsSystemAPI {
  final WebOsBindingsAPI _bindings;

  WebOsSystem(this._bindings);

  @override
  void debug() => _bindings.debugMode();
  @override
  Future<bool> powerOff() {
    final (port, future) = utils.singleBooleanMessage();
    _bindings.turnOff(port);

    return future;
  }
}
