import 'package:web_os_control/controllers/tv_state.dart';

abstract interface class WebOsPointerController {
  Future<TvState> scroll(double dy);

  Future<TvState> moveIt(double dx, double dy, bool drag);

  Future<TvState> click();
}
