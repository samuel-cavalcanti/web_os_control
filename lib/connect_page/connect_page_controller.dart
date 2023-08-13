import 'package:flutter/material.dart';
import 'package:web_os/web_os.dart';
import 'package:web_os/web_os_client_api/web_os_client_api.dart';

import 'package:web_os_control/web_os_control_routers.dart' as routers;

enum DiscoveryState {
  searching,
  finished;
}

enum TvState { connected, disconect, connecting }

Stream<(List<WebOsNetworkInfo>, DiscoveryState)> discovery() async* {
  yield ([], DiscoveryState.searching);
  var tvs = await WEB_OS.network.discoveryTv();

  while (tvs.isEmpty) {
    var tvs = await WEB_OS.network.discoveryTv();
    await Future.delayed(const Duration(milliseconds: 500));
    yield (tvs, DiscoveryState.searching);
  }

  yield (tvs, DiscoveryState.finished);
}

Future<TvState> turnOnTV(WebOsNetworkInfo tv, BuildContext context) =>
    nextPage(WEB_OS.network.turnOnTV(tv), context);

Future<TvState> connect(WebOsNetworkInfo tv, BuildContext context) =>
    nextPage(WEB_OS.network.connectToTV(tv), context);

Future<TvState> nextPage(Future<bool> webOsFuture, BuildContext context) {
  webOsFuture.then((status) {
    if (status) {
      Navigator.of(context).pushNamed(routers.remoteControlPage);
    }
  });
  return toTvState(webOsFuture);
}

Future<TvState> toTvState(Future<bool> webOsFuture) async {
  final status = await webOsFuture;

  if (status) {
    return TvState.connected;
  } else {
    return TvState.disconect;
  }
}

Future<WebOsNetworkInfo?> loadLastTv() => WEB_OS.network.loadLastTvInfo();
