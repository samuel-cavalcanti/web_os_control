import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:web_os/web_os_client_api/web_os_client_api.dart';
import 'package:web_os_control/controllers/tv_state.dart';
import 'package:web_os_control/controllers/web_os_controllers_interface/web_os_network_controller.dart';
import 'package:web_os_control/controllers/web_os_controllers_interface/web_os_system_controller.dart';
import 'components/error_message.dart';
import 'components/tv_list_view.dart';
import 'components/turn_on_tv_button.dart';
import 'components/warning_message.dart';
import 'components/connect_page_title.dart';

import 'package:web_os_control/web_os_control_routers.dart' as routers;
import 'package:web_os_control/controllers/controllers.dart' as controllers;

class ConnectPage extends StatefulWidget {
  const ConnectPage({super.key});

  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  final _networkController =
      controllers.getController<WebOsNetworkController>();
  final _systemController = controllers.getController<WebOsSystemController>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final stream = _networkController.discovery().asBroadcastStream();
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
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
        Card(
          elevation: 15,
          child: ListTile(
            leading: const Icon(Icons.tv),
            title: Text(tv.name, style: Theme.of(context).textTheme.bodyMedium),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'IPv4: ${tv.ip}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                //Text(
                //  'MAC: ${tv.mac}',
                //  style: Theme.of(context).textTheme.bodySmall,
                //)
              ],
            ),
            trailing:
                TurnOnTVButton(onPress: () => _systemController.turnON(tv)),
          ),
        )
      ]);
    }

    if (snapshot.hasError) {
      return ErrorMessage(msg: ' ${snapshot.error}');
    }

    return Container();
  }

  Widget buildTVList(BuildContext context,
      AsyncSnapshot<(List<WebOsTV>, DiscoveryState)> snapshot) {
    if (snapshot.hasData) {
      debugPrint('Update view, ${snapshot.data}');
      final (tvs, state) = snapshot.data!;
      if (tvs.isEmpty) {
        if (state == DiscoveryState.searching) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: WarningMessage(
                msg: 'Are you connected to the same Wifi as your TV ?'),
          );
        } else {
          return Center(
            child: ElevatedButton.icon(
              label: const Text('Search'),
              icon: const Icon(Icons.search),
              onPressed: _refresh,
            ),
          );
        }
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
      return Card(elevation: 2, child: ErrorMessage(msg: "${snapshot.error}"));
    } else {
      return Container();
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
