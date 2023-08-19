import 'package:web_os/web_os_client_api/web_os_client_api.dart';
import 'package:web_os_control/controllers/tv_state.dart';
import 'package:web_os_control/controllers/web_os_pointer_controller.dart';

class PointerController implements WebOsPointerController {
  final WebOsPointerAPI _api;

  PointerController(this._api);
  @override
  Future<TvState> click() => _api.click().toTVState();

  @override
  Future<TvState> moveIt(double dx, double dy, bool drag) =>
      _api.moveIt(dx, dy, drag).toTVState();

  @override
  Future<TvState> scroll(double dy) => _api.scroll(0.0, dy).toTVState();
}
