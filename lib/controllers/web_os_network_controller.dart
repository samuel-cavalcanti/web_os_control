import 'package:web_os/web_os_client_api/web_os_client_api.dart';
import 'package:web_os_control/controllers/tv_state.dart';

enum DiscoveryState {
  searching,
  finished;
}


abstract interface class WebOsNetworkController {
  Stream<(List<WebOsTV>, DiscoveryState)> discovery();

  Future<TvState> turnOnTV(WebOsTV tv);

  Future<TvState> connect(WebOsTV tv);

  Future<WebOsTV?> loadLastTv();
}
