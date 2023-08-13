import 'dart:isolate';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
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
}
