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

class _ConnectPageState extends State<ConnectPage> {
  late Future<List<web_os.WebOsNetworkInfo>> discoveryFuture;
  @override
  void initState() {
    super.initState();
    discoveryFuture = web_os.discoveryTv();
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
                child: FutureBuilder(
                  future: discoveryFuture,
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      return listName(context);
                    } else if (snapshot.hasError) {
                      return listName(context);
                    } else {
                      return Row(children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: listName(context),
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
                      child: FutureBuilder(
                        future: discoveryFuture,
                        builder: buildFuture,
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

  Widget buildFuture(BuildContext context,
      AsyncSnapshot<List<web_os.WebOsNetworkInfo>> snapshot) {
    if (snapshot.hasData) {
      return tvsList(snapshot.data!);
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

  Widget listName(BuildContext context) => Text(
        'Visible TVs',
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.merge(const TextStyle(fontWeight: FontWeight.bold)),
      );

  Future<void> _refresh() async {
    debugPrint('refreshing...');
    setState(() {
      discoveryFuture = web_os.discoveryTv();
      debugPrint('Updadte future');
    });

    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('finish refresh');
  }

  Future<TvState> connect(web_os.WebOsNetworkInfo info) async {
    final status = await web_os.connectToTV(info);

    if (status) {
      Future.delayed(const Duration(seconds: 1), () {
        debugPrint('Nest router');
        Navigator.of(context).pushNamed(routers.remoteControlPage);
        web_os.CACHE_INFO = info;
      });
      return TvState.connected;
    } else {
      return TvState.disconect;
    }
  }
}
