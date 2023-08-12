import 'package:web_os/web_os_bindings_api.dart';
import 'package:web_os/web_os_client_api/web_os_client_api.dart';

class WebOsPointer implements WebOsPointerAPI {
  final WebOsBindingsAPI _bindings;

  WebOsPointer(this._bindings);

  @override
  void click() => _bindings.click();

  @override
  void moveIt(double dx, double dy, bool drag) =>
      _bindings.moveIt(dx, dy, drag ? 1 : 0);

  @override
  void scroll(double dx, double dy) => _bindings.scroll(dx, dy);
}
