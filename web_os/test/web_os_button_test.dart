import 'dart:isolate';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:web_os/web_os_button.dart';
import 'package:web_os/web_os_client_api/web_os_client_api.dart';
import 'web_os_network_test.mocks.dart';

void main() {
  test('WebOs button', () async {
    final mock = MockWebOsBindingsAPI();
    final button = WebOsButton(mock);

    final apps = [
      WebOsTvApp.youTube,
      WebOsTvApp.netflix,
      WebOsTvApp.amazonPrimeVideo
    ];

    for (final app in apps) {
      final ok = button.pressedWebOsTVApp(app);
      final args = verify(mock.launchApp(app.code, captureAny)).captured;
      final send = args[0] as SendPort;

      send.send(true);
      expect(await ok, true);
    }

    final motions = [
      MotionKey.up,
      MotionKey.down,
      MotionKey.left,
      MotionKey.right
    ];

    for (final m in motions) {
      final ok = button.pressedMotionKey(m);
      final send = verify(mock.pressedButton(m.code, captureAny)).captured[0];

      send.send(true);
      expect(await ok, true);
    }
  });
}
