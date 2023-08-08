import 'package:flutter/widgets.dart';
import 'package:web_os_control/connect_page/connect_page.dart';
import 'package:web_os_control/remote_control_page/remote_control_page.dart';

const String remoteControlPage = "RemoteControlPage";
const String connectToTVPage = "ConnectToTVPage";

Map<String, Widget Function(BuildContext)> routers = {
  remoteControlPage: (context) => const RemoteControlPage(),
  connectToTVPage: (context) => const ConnectPage(),
};
