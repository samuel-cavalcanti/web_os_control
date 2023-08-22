import 'package:web_os/web_os_client_api/web_os_client_api.dart';
import 'package:web_os_control/controllers/tv_state.dart';
import 'package:web_os_control/controllers/web_os_controllers_interface/web_os_network_controller.dart';

class NetworkController implements WebOsNetworkController {
  final WebOsNetworkAPI networkAPI;

  NetworkController(
      {required this.networkAPI,
      this.maxDiscoveryTries = 5,
      this.discoveryDelay = const Duration(seconds: 1, milliseconds: 500)});

  final int maxDiscoveryTries;
  final Duration discoveryDelay;
  bool _stopDiscovery = false;

  @override
  Stream<(List<WebOsTV>, DiscoveryState)> discovery() async* {
    yield ([], DiscoveryState.searching);
    var tvs = await networkAPI.discoveryTv();
    _stopDiscovery = false;

    for (int tries = 0;
        tries < maxDiscoveryTries && _stopDiscovery == false;
        tries++) {
      tvs = await networkAPI.discoveryTv();
      await Future.delayed(discoveryDelay);
      yield (tvs, DiscoveryState.searching);
    }

    yield (tvs, DiscoveryState.finished);
  }

  @override
  Future<TvState> connect(WebOsTV tv) => _toTvState(networkAPI.connectToTV(tv));

  Future<TvState> _toTvState(Future<bool> webOsFuture) {
    _stopDiscovery = true;

    return webOsFuture.toTVState();
  }

  @override
  Future<WebOsTV?> loadLastTv() => networkAPI.loadLastTvInfo();
}
