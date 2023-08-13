import 'dart:isolate';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:web_os/web_os_audio.dart';
import 'web_os_network_test.mocks.dart';

void main() {
  test('Change Volume', () async {
    final mock = MockWebOsBindingsAPI();

    final audio = WebOsAudio(mock);

    var ok = audio.incrementVolume();
    var send = verify(mock.incrementVolume(captureAny)).captured[0] as SendPort;

    send.send(true);
    expect(await ok, true);

    ok = audio.decreaseVolume();
    send = verify(mock.decreaseVolume(captureAny)).captured[0] as SendPort;

    send.send(true);
    expect(await ok, true);
  });

  test('Set Mute', () async {
    final mock = MockWebOsBindingsAPI();

    final audio = WebOsAudio(mock);

    var ok = audio.setMute(true);
    var send = verify(mock.setMute(1, captureAny)).captured[0] as SendPort;

    send.send(true);
    expect(await ok, true);

    ok = audio.setMute(false);

    send = verify(mock.setMute(0, captureAny)).captured[0] as SendPort;

    send.send(true);
    expect(await ok, true);
  });
}
