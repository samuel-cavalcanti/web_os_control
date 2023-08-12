import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:web_os/web_os_pointer.dart';
import 'web_os_network_test.mocks.dart';

void main() {
  test('WebOs pointer', () {
    final mock = MockWebOsBindingsAPI();
    final pointer = WebOsPointer(mock);

    pointer.moveIt(1.0, 1.0, true);
    pointer.moveIt(1.0, 2.0, false);

    pointer.scroll(0.0, 2.0);

    pointer.click();

    verifyInOrder([
      mock.moveIt(1.0, 1.0, 1),
      mock.moveIt(1.0, 2.0, 0),
    ]);

    verify(mock.scroll(0.0, 2.0));

    verify(mock.click()).called(1);
  });
}
