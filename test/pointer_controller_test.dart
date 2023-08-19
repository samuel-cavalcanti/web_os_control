import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:web_os/web_os_client_api/web_os_client_api.dart';
import 'package:mockito/annotations.dart';
import 'package:web_os_control/controllers/pointer_controller.dart';
import 'package:web_os_control/controllers/tv_state.dart';

import 'pointer_controller_test.mocks.dart';

@GenerateNiceMocks([MockSpec<WebOsPointerAPI>()])
void main() {
  test('Test Click', () async {
    final mock = MockWebOsPointerAPI();
    final controller = PointerController(mock);

    for (final state in [false, true]) {
      when(mock.click()).thenAnswer((_) async {
        return state;
      });

      final tvState = await controller.click();

      if (state) {
        expect(TvState.connected, tvState);
      } else {
        expect(TvState.disconect, tvState);
      }
    }
  });

  test('Test scroll', () async {
    final mock = MockWebOsPointerAPI();
    final controller = PointerController(mock);

    for (final state in [false, true]) {
      for (final dy in [0.2, 0.3, 0.1]) {
        when(mock.scroll(captureAny, captureAny)).thenAnswer((_) async {
          return state;
        });

        final tvState = await controller.scroll(dy);

        if (state) {
          expect(TvState.connected, tvState);
        } else {
          expect(TvState.disconect, tvState);
        }
      }
    }
  });

  test('Test move Pointer', () async {
    final mock = MockWebOsPointerAPI();
    final controller = PointerController(mock);

    for (final state in [false, true]) {
      for (final pos in [(0.1, 0.1), (0.2, 0.2), (0.3, 0.3)]) {
        when(mock.moveIt(captureAny, captureAny, captureAny))
            .thenAnswer((_) async {
          return state;
        });

        final tvState = await controller.moveIt(pos.$1, pos.$1, false);

        if (state) {
          expect(TvState.connected, tvState);
        } else {
          expect(TvState.disconect, tvState);
        }
      }
    }
  });
}


