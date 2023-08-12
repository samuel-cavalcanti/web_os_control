import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:web_os/web_os_channel.dart';
import 'web_os_network_test.mocks.dart';

void main() {
  test('Update channel', () {
    final mock = MockWebOsBindingsAPI();
    final channel = WebOsChannel(mock);

    channel.decreaseChannel();
    channel.incrementChannel();

    verify(mock.decreaseChannel()).called(1);
    verify(mock.incrementChannel()).called(1);
  });
}
