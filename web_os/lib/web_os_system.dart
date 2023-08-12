import 'package:web_os/web_os_bindings_api.dart';
import 'package:web_os/web_os_client_api/web_os_client_api.dart';

class WebOsSystem implements WebOsSystemAPI {
  final WebOsBindingsAPI _bindings;

  WebOsSystem(this._bindings);

  @override
  void debug() => _bindings.debugMode();
  @override
  void powerOff() => _bindings.turnOff();
}
