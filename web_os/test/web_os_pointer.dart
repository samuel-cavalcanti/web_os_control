import 'dart:isolate';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:web_os/web_os_pointer.dart';
import 'web_os_network_test.mocks.dart';

void main() {
  test('WebOs pointer', () async {
    final mock = MockWebOsBindingsAPI();
    final pointer = WebOsPointer(mock);

    var ok = pointer.moveIt(1.0, 1.0, true);

    var send =
        verify(mock.moveIt(1.0, 1.0, 1, captureAny)).captured[0] as SendPort;

    send.send(true);
    expect(await ok, true);

    ok = pointer.moveIt(1.0, 2.0, false);

    send = verify(mock.moveIt(1.0, 2.0, 0, captureAny)).captured[0] as SendPort;

    send.send(true);
    expect(await ok, true);

    ok = pointer.moveIt(3.0, 4.0, false);

    send = verify(mock.moveIt(3.0, 4.0, 0, captureAny)).captured[0] as SendPort;

    send.send(false);
    expect(await ok, false);

    ok = pointer.scroll(0.0, 2.0);

    send = verify(mock.scroll(0.0, 2.0, captureAny)).captured[0] as SendPort;

    send.send(true);
    expect(await ok, true);

    ok = pointer.click();

    send = verify(mock.click(captureAny)).captured[0] as SendPort;

    send.send(true);
    expect(await ok, true);
  });
}
