import 'package:flutter/widgets.dart';
import 'package:web_os/web_os.dart';
import 'package:web_os_control/controllers/network_controller.dart';
import 'package:web_os_control/pages/connect_page/connect_page.dart';
import 'package:web_os_control/pages/remote_control_page/remote_control_page.dart';

const String remoteControlPage = "RemoteControlPage";
const String connectToTVPage = "ConnectToTVPage";

Map<String, Widget Function(BuildContext)> routers = {
  remoteControlPage: (context) => const RemoteControlPage(),
  connectToTVPage: (context) =>  ConnectPage(
      controller: NetworkController(networkAPI: WEB_OS.network)),
};
