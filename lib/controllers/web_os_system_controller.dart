import 'package:web_os_control/controllers/tv_state.dart';

abstract interface class WebOsSystemController {
  Future<TvState> turnOff();
}
