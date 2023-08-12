import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:web_os/web_os_audio.dart';
import 'web_os_network_test.mocks.dart';

void main() {
  test('Change Volume', () {
    final mock = MockWebOsBindingsAPI();

    final audio = WebOsAudio(mock);

    audio.incrementVolume();
    audio.decreaseVolume();

    verify(mock.decreaseVolume()).called(1);
    verify(mock.incrementVolume()).called(1);
  });

  test('Set Mute', () {
    final mock = MockWebOsBindingsAPI();

    final audio = WebOsAudio(mock);

    audio.setMute(true);

    audio.setMute(false);

    verifyInOrder([
      mock.setMute(1),
      mock.setMute(0),
    ]);
  });
}
