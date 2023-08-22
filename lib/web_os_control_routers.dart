import 'package:flutter/widgets.dart';
import 'package:web_os_control/pages/connect_page/connect_page.dart';
import 'package:web_os_control/pages/remote_control_page/remote_control_page.dart';

const String remoteControlPage = "/remote_control_page";
const String connectToTVPage = "/connect_to_tv_page";

Map<String, Widget Function(BuildContext)> routers = {
  remoteControlPage: (context) => const RemoteControlPage(),
  connectToTVPage: (context) => const ConnectPage(),
};
