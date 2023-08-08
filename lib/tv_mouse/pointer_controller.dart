import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:web_os/web_os.dart' as web_os;

void onClick() => web_os.pointerClick();

void onMove(PointerHoverEvent event) {
  const scale = 2.0;
  final dx = event.delta.dx * scale;
  final dy = event.delta.dy * scale;
  web_os.pointerMoveIt(dx, dy, false);
}

void connect() {
  debugPrint("Clicked on connect button");
  const info = web_os.WebOsNetworkInfo(
      ip: "192.168.0.199", mac: "04:a2:22:a6:0f:3e", name: "LG Web Os");
  web_os.connectToTV(info);
}
