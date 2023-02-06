import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web_os_control/web_os_remote_control_app.dart';
import 'package:web_os/web_os.dart' as web_os;
import 'package:web_os_control/tv_mouse/pointer_controller.dart'
    as pointer_controller;

void main() {
  if (kDebugMode && Platform.isLinux) {
    web_os.debugMode();
    pointer_controller.connect();
  }

  runApp(WebOsRemoteControlApp());
}
