import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:web_os/web_os_client_api/web_os_botton_api.dart';
import 'package:web_os_control/controllers/button_controller.dart';
import 'package:web_os_control/controllers/tv_state.dart';

@GenerateNiceMocks([MockSpec<WebOsButtonAPI>()])
import 'web_os_button_controller.mocks.dart';

void expectTVState(bool state, TvState tvState) {
  if (state) {
    expect(TvState.connected, tvState);
  } else {
    expect(TvState.disconect, tvState);
  }
}

void main() {
  test('Test Pressed Media player button', () async {
    final mock = MockWebOsButtonAPI();
    final controller = ButtonController(mock);

    for (final key in MediaPlayerKey.values) {
      for (final state in [true, false]) {
        when(mock.pressedMediaPlayerKey(key)).thenAnswer((_) async {
          return state;
        });
        final tvState = await controller.pressMediaPlayerKey(key);

        expectTVState(state, tvState);
      }
    }
  });
  test('Test Pressed Motion button', () async {
    final mock = MockWebOsButtonAPI();
    final controller = ButtonController(mock);

    for (final key in MotionKey.values) {
      for (final state in [true, false]) {
        when(mock.pressedMotionKey(key)).thenAnswer((_) async {
          return state;
        });

        final tvState = await controller.pressMotionKey(key);

        expectTVState(state, tvState);
      }
    }
  });
  test('Test Pressed WebOs Tv App button', () async {
    final mock = MockWebOsButtonAPI();
    final controller = ButtonController(mock);

    for (final key in WebOsTvApp.values) {
      for (final state in [true, false]) {
        when(mock.pressedWebOsTVApp(key)).thenAnswer((_) async {
          return state;
        });

        final tvState = await controller.pressWebOsApp(key);

        expectTVState(state, tvState);
      }
    }
  });
}
