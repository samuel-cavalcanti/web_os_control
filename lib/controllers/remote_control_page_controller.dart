import 'package:flutter/widgets.dart';
import 'package:web_os/web_os_client_api/web_os_client_api.dart';
import 'package:web_os_control/controllers/tv_state.dart';
import 'package:web_os_control/controllers/web_os_controllers_interface/web_os_network_controller.dart';

import 'package:web_os_control/web_os_control_routers.dart' as routers;

class RemoteControlPageController {
  final NavigatorState nav;
  final WebOsNetworkController networkController;

  RemoteControlPageController(this.nav, {required this.networkController});

  void _backPage(Future<TvState> reconect) async {
    if (await reconect == TvState.disconect) {
      nav.popAndPushNamed(routers.connectToTVPage);
    }
  }

  void _pressTask(Future<TvState> Function() callBack) {
    final r = _reconect(callBack);
    _backPage(r);
  }

  Future<TvState> _reconect(Future<TvState> Function() webOsFuture) async {
    if (await webOsFuture() == TvState.disconect) {
      final lastTv = await networkController.loadLastTv();
      if (lastTv == null) return TvState.disconect;

      if (await networkController.connect(lastTv) == TvState.connected) {
        return webOsFuture();
      } else {
        return TvState.disconect;
      }
    } else {
      return TvState.connected;
    }
  }
}

extension TryToReconect on Future<TvState> Function() {
  Future<TvState> reconnect(WebOsNetworkController controller) async {
    if (await this() == TvState.disconect) {
      final lastTv = await controller.loadLastTv();
      if (lastTv == null) return TvState.disconect;

      if (await controller.connect(lastTv) == TvState.connected) {
        return this();
      } else {
        return TvState.disconect;
      }
    } else {
      return TvState.connected;
    }
  }
}
