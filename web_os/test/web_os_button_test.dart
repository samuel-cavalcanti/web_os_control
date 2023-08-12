import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:web_os/web_os_button.dart';
import 'package:web_os/web_os_client_api/web_os_client_api.dart';
import 'web_os_network_test.mocks.dart';

void main() {
  test('WebOs button', () {
    final mock = MockWebOsBindingsAPI();
    final button = WebOsButton(mock);

    final apps = [
      WebOsTvApp.youTube,
      WebOsTvApp.netflix,
      WebOsTvApp.amazonPrimeVideo
    ];

    for (final app in apps) {
      button.pressedWebOsTVApp(app);
    }
    verifyInOrder([
      mock.launchApp(WebOsTvApp.youTube.code),
      mock.launchApp(WebOsTvApp.netflix.code),
      mock.launchApp(WebOsTvApp.amazonPrimeVideo.code),
    ]);

    final motions = [
      MotionKey.up,
      MotionKey.down,
      MotionKey.left,
      MotionKey.right
    ];

    for (final m in motions) {
      button.pressedMotionKey(m);
    }

    verifyInOrder([
      mock.pressedButton(MotionKey.up.code),
      mock.pressedButton(MotionKey.down.code),
      mock.pressedButton(MotionKey.left.code),
      mock.pressedButton(MotionKey.right.code),
    ]);

  });
}
