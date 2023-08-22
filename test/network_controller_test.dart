import 'package:flutter_test/flutter_test.dart';
import 'package:web_os/web_os_client_api/web_os_client_api.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:web_os_control/controllers/network_controller.dart';
import 'package:web_os_control/controllers/tv_state.dart';
import 'package:web_os_control/controllers/web_os_controllers_interface/web_os_network_controller.dart';

@GenerateNiceMocks([MockSpec<WebOsNetworkAPI>()])
import 'network_controller_test.mocks.dart';

void expectSearch(List<(List<WebOsTV>, DiscoveryState)> result,
    List<(List<WebOsTV>, DiscoveryState)> expects,
    {String? reason}) {
  expect(expects.length, result.length, reason: reason);
  for (int i = 0; i < result.length; i++) {
    final e = expects[i];
    final r = result[i];

    expect(e.$1, r.$1, reason: reason);
    expect(e.$2, r.$2, reason: reason);
  }
}

const TV = WebOsTV(ip: "123", name: "test", mac: "123");

void main() {
  test('Test Discovery Tvs', () async {
    final mock = MockWebOsNetworkAPI();
    final controller =
        NetworkController(networkAPI: mock, discoveryDelay: Duration.zero);

    final tvs = [TV];
    final tvsStream = controller.discovery();

    when(mock.discoveryTv()).thenAnswer((_) => Future.microtask(() => tvs));

    final expects = [
      (<WebOsTV>[], DiscoveryState.searching),
      // 5 tries
      (tvs, DiscoveryState.finished),
    ];

    final result = await tvsStream.toList();

    expectSearch(result, expects);
  });

  test('Test Load last TV', () async {
    final mock = MockWebOsNetworkAPI();
    final controller =
        NetworkController(networkAPI: mock, discoveryDelay: Duration.zero);

    when(mock.loadLastTvInfo()).thenAnswer((_) async {
      return TV;
    });

    var tv = controller.loadLastTv();

    expect(await tv, TV);

    when(mock.loadLastTvInfo()).thenAnswer((_) async {
      return null;
    });

    tv = controller.loadLastTv();

    expect(await tv, null);
  });

  test('Test connect TV', () async {
    final mock = MockWebOsNetworkAPI();
    final controller =
        NetworkController(networkAPI: mock, discoveryDelay: Duration.zero);

    when(mock.connectToTV(TV)).thenAnswer((_) async {
      return true;
    });

    var status = await controller.connect(TV);
    expect(status, TvState.connected);

    when(mock.connectToTV(TV)).thenAnswer((_) async {
      return false;
    });

    status = await controller.connect(TV);
    expect(status, TvState.disconect);
  });
}
