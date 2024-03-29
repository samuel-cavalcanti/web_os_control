import 'package:web_os/web_os_client_api/web_os_client_api.dart';
import 'package:web_os_control/controllers/tv_state.dart';
import 'package:web_os_control/controllers/web_os_controllers_interface/web_os_system_controller.dart';

class SystemController implements WebOsSystemController {
  final WebOsSystemAPI _systemAPI;

  SystemController(this._systemAPI);

  @override
  Future<TvState> turnOff() async {
    await _systemAPI.powerOff();
    return TvState.disconect;
  }

  @override
  Future<TvState> turnON(WebOsTV tv) async {
    await _systemAPI.turnOnTV(tv);
    return TvState.disconect;
  }
}
