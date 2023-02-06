import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:web_os/web_os.dart' as web_os;

typedef MotionKey = web_os.MotionKey;

const pressedMotionKey = web_os.pressedMotionKey;
//typedef pressedMotionKey = web_os.pressedMotionKey;

final _logicKeyToMotionKey = {
  LogicalKeyboardKey.arrowUp: MotionKey.up,
  LogicalKeyboardKey.arrowDown: MotionKey.down,
  LogicalKeyboardKey.arrowLeft: MotionKey.left,
  LogicalKeyboardKey.arrowRight: MotionKey.right,
  LogicalKeyboardKey.enter: MotionKey.enter,
  LogicalKeyboardKey.escape: MotionKey.back,
  LogicalKeyboardKey.home: MotionKey.home,
};

void onKeyPress(RawKeyEvent event) {
  final key = event.logicalKey;

  final motionKey = _logicKeyToMotionKey[key];
  if (event.isKeyPressed(key) && motionKey != null) {
    pressedMotionKey(motionKey);
  }

  debugPrint("key: $key");
}
