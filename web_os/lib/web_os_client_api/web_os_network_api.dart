
import 'web_os_tv.dart';

abstract interface class WebOsNetworkAPI {
  Future<List<WebOsTV>> discoveryTv();
  Future<bool> connectToTV(WebOsTV info);
  Future<WebOsTV?> loadLastTvInfo();
}
