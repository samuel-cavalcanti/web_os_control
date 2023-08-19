import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:web_os/web_os_client_api/web_os_system_api.dart';
import 'package:web_os_control/controllers/system_controller.dart';
import 'package:web_os_control/controllers/tv_state.dart';

import 'system_controller_test.mocks.dart';

@GenerateNiceMocks([MockSpec<WebOsSystemAPI>()])
void main() {
  test('Test power Off', () async {
    final mock = MockWebOsSystemAPI();

    final controller = SystemController(mock);

    when(mock.powerOff()).thenAnswer((_) async {
      return true;
    });

    var status = controller.turnOff();

    expect(await status, TvState.connected);

    when(mock.powerOff()).thenAnswer((_) async {
      return false;
    });

    status = controller.turnOff();

    expect(await status, TvState.disconect);
  });
}
