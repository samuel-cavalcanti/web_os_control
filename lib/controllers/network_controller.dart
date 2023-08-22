import 'package:web_os/web_os_client_api/web_os_client_api.dart';
import 'package:web_os_control/controllers/tv_state.dart';
import 'package:web_os_control/controllers/web_os_controllers_interface/web_os_network_controller.dart';

class NetworkController implements WebOsNetworkController {
  final WebOsNetworkAPI networkAPI;

  NetworkController(
      {required this.networkAPI,
      this.discoveryDelay = const Duration(seconds: 1, milliseconds: 500)});

  final Duration discoveryDelay;

  @override
  Stream<(List<WebOsTV>, DiscoveryState)> discovery() async* {
    yield ([], DiscoveryState.searching);
    var tvs = await networkAPI.discoveryTv();

    yield (tvs, DiscoveryState.finished);
  }

  @override
  Future<TvState> connect(WebOsTV tv) => _toTvState(networkAPI.connectToTV(tv));

  Future<TvState> _toTvState(Future<bool> webOsFuture) {
    return webOsFuture.toTVState();
  }

  @override
  Future<WebOsTV?> loadLastTv() => networkAPI.loadLastTvInfo();
}
