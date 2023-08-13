import 'dart:isolate';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:web_os/web_os_channel.dart';
import 'web_os_network_test.mocks.dart';

void main() {
  test('Update channel', () async {
    final mock = MockWebOsBindingsAPI();
    final channel = WebOsChannel(mock);

    var ok = channel.decreaseChannel();

    var send = verify(mock.decreaseChannel(captureAny)).captured[0] as SendPort;

    send.send(true);
    expect(await ok, true);

    ok = channel.incrementChannel();
    send = verify(mock.incrementChannel(captureAny)).captured[0];

    send.send(true);
    expect(await ok, true);
  });
}
