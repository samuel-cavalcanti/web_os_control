import 'package:flutter/widgets.dart';
import 'package:web_os/web_os_client_api/web_os_client_api.dart';

import 'package:web_os/web_os.dart' as web_os;
import 'package:web_os_control/web_os_control_routers.dart' as routers;



class RemoteControlPageController {
  final NavigatorState nav;

  RemoteControlPageController(this.nav);

  void _backPage(Future<bool> reconect) async {
    if (await reconect == false) {
      nav.popAndPushNamed(routers.connectToTVPage);
    }
  }

  void _pressTask(Future<bool> Function() callBack) {
    final r = _reconect(web_os.WEB_OS.network, callBack);
    _backPage(r);
  }

  Future<bool> _reconect(
      WebOsNetworkAPI network, Future<bool> Function() webOsFuture) async {
    if (await webOsFuture() == false) {
      final lastTv = await network.loadLastTvInfo();
      if (lastTv == null) return false;

      if (await network.connectToTV(lastTv)) {
        return webOsFuture();
      } else {
        return false;
      }
    } else {
      return true;
    }
  }


  void onScroll(double dy) => _pressTask(
        () => web_os.WEB_OS.pointer.scroll(0.0, -dy),
      );



}
