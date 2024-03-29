import 'package:flutter/material.dart';

// web_os deps
import 'package:web_os/web_os.dart' as web_os;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:web_os_control/web_os_remote_control_app.dart';

void main() {
  final isSuppordedPlatform = Platform.isLinux || Platform.isAndroid;
  if (isSuppordedPlatform) {
    web_os.setup();
    if (kDebugMode) {
      try {
        web_os.WEB_OS.system.debug();
      } catch (e) {
        debugPrint('Error e $e');
      }
    }
  }
  if (kDebugMode && isSuppordedPlatform) {}

  runApp(const WebOsRemoteControlApp());
}
