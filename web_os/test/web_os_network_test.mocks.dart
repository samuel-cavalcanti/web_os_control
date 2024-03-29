// Mocks generated by Mockito 5.4.2 from annotations
// in web_os/test/web_os_network_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:isolate' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:web_os/web_os_bindings_api.dart' as _i2;
import 'package:web_os/web_os_bindings_generated.dart' as _i4;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [WebOsBindingsAPI].
///
/// See the documentation for Mockito's code generation for more information.
class MockWebOsBindingsAPI extends _i1.Mock implements _i2.WebOsBindingsAPI {
  @override
  void pressedButton(
    int? code,
    _i3.SendPort? port,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #pressedButton,
          [
            code,
            port,
          ],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void launchApp(
    int? code,
    _i3.SendPort? port,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #launchApp,
          [
            code,
            port,
          ],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void pressedMediaPlayerButton(
    int? code,
    _i3.SendPort? port,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #pressedMediaPlayerButton,
          [
            code,
            port,
          ],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void turnOn(
    _i4.WebOsNetworkInfoFFI? info,
    _i3.SendPort? port,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #turnOn,
          [
            info,
            port,
          ],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void turnOff(_i3.SendPort? port) => super.noSuchMethod(
        Invocation.method(
          #turnOff,
          [port],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void connectToTV(
    _i4.WebOsNetworkInfoFFI? info,
    _i3.SendPort? port,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #connectToTV,
          [
            info,
            port,
          ],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void loadLastTvInfo(_i3.SendPort? port) => super.noSuchMethod(
        Invocation.method(
          #loadLastTvInfo,
          [port],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void discoveryBySSDP(_i3.SendPort? port) => super.noSuchMethod(
        Invocation.method(
          #discoveryBySSDP,
          [port],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void moveIt(
    double? dx,
    double? dy,
    int? drag,
    _i3.SendPort? port,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #moveIt,
          [
            dx,
            dy,
            drag,
            port,
          ],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void scroll(
    double? scrollDx,
    double? scrollDy,
    _i3.SendPort? port,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #scroll,
          [
            scrollDx,
            scrollDy,
            port,
          ],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void click(_i3.SendPort? port) => super.noSuchMethod(
        Invocation.method(
          #click,
          [port],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void incrementVolume(_i3.SendPort? port) => super.noSuchMethod(
        Invocation.method(
          #incrementVolume,
          [port],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void decreaseVolume(_i3.SendPort? port) => super.noSuchMethod(
        Invocation.method(
          #decreaseVolume,
          [port],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void setMute(
    int? mute,
    _i3.SendPort? port,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #setMute,
          [
            mute,
            port,
          ],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void incrementChannel(_i3.SendPort? port) => super.noSuchMethod(
        Invocation.method(
          #incrementChannel,
          [port],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void decreaseChannel(_i3.SendPort? port) => super.noSuchMethod(
        Invocation.method(
          #decreaseChannel,
          [port],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void debugMode() => super.noSuchMethod(
        Invocation.method(
          #debugMode,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
