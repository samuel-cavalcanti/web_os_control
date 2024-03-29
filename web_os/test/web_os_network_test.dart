import 'dart:isolate';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:web_os/web_os_bindings_api.dart';
import 'package:web_os/web_os_client_api/web_os_client_api.dart';
import 'package:web_os/web_os_network.dart';

@GenerateNiceMocks([MockSpec<WebOsBindingsAPI>()])
import 'web_os_network_test.mocks.dart';

void main() {
  test('Test WebOS Connect to TV', () async {
    final mock = MockWebOsBindingsAPI();

    final network = WebOsNetwork(mock);
    const tv = WebOsTV(ip: "192.168.0.1", name: "WEB OS", mac: "123");

    for (final message in [true, false]) {
      final ok = network.connectToTV(tv);

      final args = verify(mock.connectToTV(captureAny, captureAny)).captured;

      final send = args[1] as SendPort;

      send.send(message);

      expect(await ok, message);
    }
  });


  test('Test WebOS discovery TVs', () async {
    final mock = MockWebOsBindingsAPI();

    final network = WebOsNetwork(mock);

    final future = network.discoveryTv();

    final arg = verify(mock.discoveryBySSDP(captureAny)).captured[0];

    final send = arg as SendPort;

    final tvArray = ["192.168.0.1", "Web os", "123"];
    send.send([tvArray]);

    final tvs = await future;

    expect(tvs.length, 1);

    expect(tvs.first.ip, tvArray[0]);
    expect(tvs.first.name, tvArray[1]);
    expect(tvs.first.mac, tvArray[2]);
  });

  test('Test WebOs load last tv info: Successful', () async {
    final mock = MockWebOsBindingsAPI();

    final network = WebOsNetwork(mock);

    final future = network.loadLastTvInfo();

    final arg = verify(mock.loadLastTvInfo(captureAny)).captured[0];

    final send = arg as SendPort;

    final tvArray = <dynamic>["192.168.0.1", "Web os", "123"];
    final expectedTv =
        WebOsTV(ip: tvArray[0], name: tvArray[1], mac: tvArray[2]);

    send.send(tvArray);

    final tv = await future;

    expect(tv!.ip, expectedTv.ip);
    expect(tv.name, expectedTv.name);
    expect(tv.mac, expectedTv.mac);
  });

  test('Test WebOs load last tv info: Not Found', () async {
    final mock = MockWebOsBindingsAPI();

    final network = WebOsNetwork(mock);

    final future = network.loadLastTvInfo();

    final arg = verify(mock.loadLastTvInfo(captureAny)).captured[0];

    final send = arg as SendPort;

    send.send(null);

    final tv = await future;
    expect(tv, null);
  });
}
