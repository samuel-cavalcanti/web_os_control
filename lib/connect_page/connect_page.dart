import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'tv_item.dart';
import 'package:web_os_control/web_os_control_routers.dart' as routers;

import 'package:web_os/web_os.dart' as web_os;

class ConnectPage extends StatefulWidget {
  const ConnectPage({super.key});

  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

Stream<(List<web_os.WebOsNetworkInfo>, DiscoveryState)> discovery() async* {
  yield ([], DiscoveryState.searching);
  var tvs = await web_os.discoveryTv();

  while (tvs.isEmpty) {
    tvs = await web_os.discoveryTv();
    await Future.delayed(const Duration(seconds: 1));
    yield (tvs, DiscoveryState.searching);
  }

  yield (tvs, DiscoveryState.finished);
}

enum DiscoveryState {
  searching,
  finished;
}

class _ConnectPageState extends State<ConnectPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  stream: discovery(),
                  builder: (context, snapshot) {
                    debugPrint("snapshot: ${snapshot.data}");
                    if (snapshot.hasData) {
                      final (_, state) = snapshot.data!;

                      return state == DiscoveryState.searching
                          ? visibleTvsLoading(context)
                          : visibleTvs(context);
                    } else if (snapshot.hasError) {
                      return visibleTvs(context);
                    } else {
                      return Row(children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: visibleTvs(context),
                        ),
                        const SizedBox(
                          width: 8,
                          height: 8,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                          ),
                        )
                      ]);
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
                              stream: discovery(),
                              builder: buildTVList,
                            ),
                          ),
                          FutureBuilder(
                              future: web_os.loadLastTvInfo(),
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

  Widget buildLastTV(
      BuildContext context, AsyncSnapshot<web_os.WebOsNetworkInfo?> snapshot) {
    final tv = snapshot.data;

    if (tv != null) {
      return Column(children: [
        const Text('Last TV'),
        TvItemList(
            connect: () => nextPage(web_os.turnOn(tv)), tvNetworkInfo: tv),
      ]);
    }

    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }

    return Container();
  }

  Widget buildTVList(BuildContext context,
      AsyncSnapshot<(List<web_os.WebOsNetworkInfo>, DiscoveryState)> snapshot) {
    if (snapshot.hasData) {
      debugPrint('Update view, ${snapshot.data}');
      final (tvs, _) = snapshot.data!;
      return tvsList(tvs);
    } else if (snapshot.hasError) {
      return errorMessage(snapshot.error!);
    } else {
      return ListView(
        children: const [],
      );
    }
  }

  Widget errorMessage(error) {
    return ListView(
      children: [
        ListTile(
          title: Text(
            'Error $error',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.merge(const TextStyle(fontWeight: FontWeight.bold)),
          ),
          subtitle: const Text(
              'No TV found. Are you connected to the same Wifi as your TV ?'),
          isThreeLine: true,
        )
      ],
    );
  }

  Widget tvsList(List<web_os.WebOsNetworkInfo> infos) {
    return ListView(
        children: infos
            .map((info) => TvItemList(
                  tvNetworkInfo: info,
                  connect: () => connect(info),
                ))
            .toList(growable: false));
  }

  Widget visibleTvs(BuildContext context) => Text(
        'Visible TVs',
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.merge(const TextStyle(fontWeight: FontWeight.bold)),
      );

  Widget visibleTvsLoading(BuildContext context) => Row(children: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: visibleTvs(context),
        ),
        const SizedBox(
          width: 8,
          height: 8,
          child: CircularProgressIndicator(
            strokeWidth: 3,
          ),
        )
      ]);

  Future<void> _refresh() async {
    debugPrint('refreshing...');
    setState(() {
      debugPrint('Updadte future');
    });

    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('finish refresh');
  }

  Future<TvState> connect(web_os.WebOsNetworkInfo info) {
    final status = web_os.connectToTV(info);

    return nextPage(status);
  }

  Future<TvState> nextPage(Future<bool> webOsFuture) async {
    final status = await webOsFuture;

    if (status) {
      debugPrint('Nest router');
      Navigator.of(context).popAndPushNamed(routers.remoteControlPage);

      return TvState.connected;
    } else {
      return TvState.disconect;
    }
  }
}
