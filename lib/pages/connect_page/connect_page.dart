import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:web_os/web_os_client_api/web_os_network_api.dart';
import 'package:web_os_control/controllers/tv_state.dart';
import 'package:web_os_control/controllers/web_os_controllers_interface/web_os_network_controller.dart';
import 'package:web_os_control/pages/connect_page/error_message.dart';
import 'package:web_os_control/pages/connect_page/tv_list_view.dart';
import 'package:web_os_control/pages/connect_page/warning_message.dart';
import 'package:web_os_control/web_os_control_routers.dart' as routers;
import 'package:web_os_control/controllers/controllers.dart' as controllers;
import 'connect_page_title.dart';
import 'tv_item.dart';

class ConnectPage extends StatefulWidget {
  const ConnectPage({super.key});

  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  final _networkController = controllers.getController<WebOsNetworkController>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final stream = _networkController.discovery().asBroadcastStream();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: StreamBuilder(
                  stream: stream,
                  builder: (context, snapshot) {
                    debugPrint("snapshot: ${snapshot.data}");
                    switch (snapshot.data) {
                      case null:
                        return const ConnectPageTitle(
                            state: DiscoveryState.finished);
                      case (final _, final state):
                        return ConnectPageTitle(state: state);
                    }
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                        PointerDeviceKind.trackpad,
                      },
                    ),
                    child: RefreshIndicator(
                      onRefresh: _refresh,
                      child: Column(
                        children: [
                          Expanded(
                            child: StreamBuilder(
                              stream: stream,
                              builder: buildTVList,
                            ),
                          ),
                          FutureBuilder(
                              future: _networkController.loadLastTv(),
                              builder: buildLastTV),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLastTV(BuildContext context, AsyncSnapshot<WebOsTV?> snapshot) {
    final tv = snapshot.data;

    if (tv != null) {
      return Column(children: [
        const Text('Last TV'),
        TvItemList(
            connect: () {
              final future = _networkController.turnOnTV(tv);
              future.then(nextPage);
              return future;
            },
            tvNetworkInfo: tv),
      ]);
    }

    if (snapshot.hasError) {
      return ErrorMessage(msg: ' ${snapshot.error}');
    }

    return Container();
  }

  Widget buildTVList(BuildContext context,
      AsyncSnapshot<(List<WebOsTV>, DiscoveryState)> snapshot) {
    const warningMsg =
        WarningMessage(msg: 'Are you connected to the same Wifi as your TV ?');
    if (snapshot.hasData) {
      debugPrint('Update view, ${snapshot.data}');
      final (tvs, _) = snapshot.data!;
      if (tvs.isEmpty) {
        return warningMsg;
      } else {
        return TVListView(
            tvs: tvs,
            onTab: (tv) {
              final future = _networkController.connect(tv);
              future.then(nextPage);
              return future;
            });
      }
    } else if (snapshot.hasError) {
      return ErrorMessage(msg: "${snapshot.error}");
    } else {
      return warningMsg;
    }
  }

  void nextPage(TvState state) {
    if (state == TvState.connected) {
      Navigator.of(context).popAndPushNamed(routers.remoteControlPage);
    }
  }

  Future<void> _refresh() async {
    debugPrint('refreshing...');
    setState(() {
      debugPrint('Updadte future');
    });

    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('finish refresh');
  }
}
