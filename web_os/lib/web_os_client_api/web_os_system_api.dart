
import 'web_os_tv.dart';

abstract interface class WebOsSystemAPI {
  Future<bool> powerOff();
  Future<bool> turnOnTV(WebOsTV info);

  void debug();
}
