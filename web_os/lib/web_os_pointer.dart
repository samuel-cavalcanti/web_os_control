import 'package:web_os/web_os_bindings_api.dart';
import 'package:web_os/web_os_client_api/web_os_client_api.dart';
import 'utils.dart' as utils;

class WebOsPointer implements WebOsPointerAPI {
  final WebOsBindingsAPI _bindings;

  WebOsPointer(this._bindings);

  @override
  Future<bool> click() {
    final (port, future) = utils.singleBooleanMessage();
    _bindings.click(port);

    return future;
  }

  @override
  Future<bool> moveIt(double dx, double dy, bool drag) {
    final (port, future) = utils.singleBooleanMessage();
    _bindings.moveIt(dx, dy, drag ? 1 : 0, port);

    return future;
  }

  @override
  Future<bool> scroll(double dx, double dy) {
    final (port, future) = utils.singleBooleanMessage();
    _bindings.scroll(dx, dy, port);

    return future;
  }
}
