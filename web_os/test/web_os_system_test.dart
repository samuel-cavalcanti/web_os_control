import 'dart:isolate';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:web_os/web_os_client_api/web_os_client_api.dart';
import 'package:web_os/web_os_system.dart';
import 'web_os_network_test.mocks.dart';

void main() {
  test('Power of tv and enable debug mode', () async {
    final mock = MockWebOsBindingsAPI();
    final system = WebOsSystem(mock);

    var ok = system.powerOff();

    var send = verify(mock.turnOff(captureAny)).captured[0] as SendPort;

    send.send(true);
    expect(await ok, true);

    ok = system.powerOff();
    send = verify(mock.turnOff(captureAny)).captured[0] as SendPort;

    send.send(false);
    expect(await ok, false);

    system.debug();

    verify(mock.debugMode()).called(1);
  });


  test('Test WebOS Turn On TV', () async {
    final mock = MockWebOsBindingsAPI();

    final network = WebOsSystem(mock);
    const tv = WebOsTV(ip: "192.168.0.1", name: "WEB OS", mac: "123");

    for (final message in [true, false]) {
      final ok = network.turnOnTV(tv);

      final args = verify(mock.turnOn(captureAny, captureAny)).captured;

      final send = args[1] as SendPort;

      send.send(message);

      expect(await ok, message);
    }
  });
}
