import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:web_os/web_os_client_api/web_os_channel_api.dart';
import 'package:web_os_control/controllers/channel_controller.dart';
import 'package:web_os_control/controllers/tv_state.dart';
import 'package:web_os_control/controllers/web_os_channel_controller.dart';

@GenerateNiceMocks([MockSpec<WebOsChannelAPI>()])
import 'channel_controller_test.mocks.dart';

void main() {
  test('Test change Channel', () async {
    final mock = MockWebOsChannelAPI();

    final controller = ChannelController(mock);

    when(mock.decreaseChannel()).thenAnswer((_) async {
      return true;
    });

    var status = await controller.pressedChannel(ChannelKey.down);

    expect(status, TvState.connected);

    when(mock.decreaseChannel()).thenAnswer((_) async {
      return false;
    });

    status = await controller.pressedChannel(ChannelKey.down);

    expect(status, TvState.disconect);


    when(mock.incrementChannel()).thenAnswer((_) async {
      return true;
    });

    status = await controller.pressedChannel(ChannelKey.up);

    expect(status, TvState.connected);



    when(mock.incrementChannel()).thenAnswer((_) async {
      return false;
    });

    status = await controller.pressedChannel(ChannelKey.up);

    expect(status, TvState.disconect);
  });
}
