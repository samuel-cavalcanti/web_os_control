import 'package:flutter/material.dart';
import 'package:web_os/web_os_client_api/web_os_client_api.dart';
import 'package:web_os_control/controllers/web_os_network_controller.dart';
import 'tv_item.dart';

class TVListView extends StatelessWidget {
  final Future<TvState> Function(WebOsTV tv) onTab;
  final List<WebOsTV> tvs;
  const TVListView({super.key, required this.onTab, required this.tvs});

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: tvs
            .map((WebOsTV tv) => TvItemList(
                  tvNetworkInfo: tv,
                  connect: () => onTab(tv),
                ))
            .toList(growable: false));
  }
}
