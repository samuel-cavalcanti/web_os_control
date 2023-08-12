import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:web_os/web_os_system.dart';
import 'web_os_network_test.mocks.dart';

void main() {
  test('Power of tv and enable debug mode', () {
    final mock = MockWebOsBindingsAPI();
    final system = WebOsSystem(mock);

    system.powerOff();
    system.debug();

    verify(mock.turnOff()).called(1);
    verify(mock.debugMode()).called(1);
  });
}
