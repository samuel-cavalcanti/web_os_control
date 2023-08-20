import 'package:flutter_test/flutter_test.dart';

import 'package:web_os/web_os_client_api/web_os_audio_api.dart';

import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:web_os_control/controllers/tv_state.dart';
import 'package:web_os_control/controllers/volume_controller.dart';
import 'package:web_os_control/controllers/web_os_controllers_interface/web_os_volume_controller.dart';

import 'volume_controller_test.mocks.dart';

@GenerateNiceMocks([MockSpec<WebOsAudioAPI>()])
void main() {
  test('Test set Volume', () async {
    final mock = MockWebOsAudioAPI();
    final controller = VolumeController(mock);

    when(mock.decreaseVolume()).thenAnswer((_) async {
      return true;
    });
    var status = await controller.setVolume(Volume.down);

    expect(status, TvState.connected);

    when(mock.decreaseVolume()).thenAnswer((_) async {
      return false;
    });

    status = await controller.setVolume(Volume.down);

    expect(status, TvState.disconect);

    when(mock.incrementVolume()).thenAnswer((_) async {
      return true;
    });

    status = await controller.setVolume(Volume.up);
    expect(status, TvState.connected);

    when(mock.incrementVolume()).thenAnswer((_) async {
      return false;
    });

    status = await controller.setVolume(Volume.up);
    expect(status, TvState.disconect);
  });

  test('Test set mute', () async {
    final mock = MockWebOsAudioAPI();
    final controller = VolumeController(mock);

    when(mock.setMute(false)).thenAnswer((_) async {
      return true;
    });

    var status = await controller.setMute(false);

    expect(status, TvState.connected);

    when(mock.setMute(false)).thenAnswer((_) async {
      return false;
    });
    status = await controller.setMute(false);

    expect(status, TvState.disconect);

    when(mock.setMute(true)).thenAnswer((_) async {
      return true;
    });
    status = await controller.setMute(true);

    expect(status, TvState.connected);

    when(mock.setMute(true)).thenAnswer((_) async {
      return false;
    });
    status = await controller.setMute(true);

    expect(status, TvState.disconect);
  });
}
