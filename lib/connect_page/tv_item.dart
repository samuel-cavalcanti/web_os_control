import 'package:flutter/material.dart';
import 'package:web_os/web_os_client_api/web_os_network_api.dart';

import './connect_page_controller.dart' as controller;

class TvItemList extends StatefulWidget {
  final WebOsNetworkInfo tvNetworkInfo;
  final Future<controller.TvState> Function() connect;
  const TvItemList(
      {super.key, required this.tvNetworkInfo, required this.connect});

  @override
  State<StatefulWidget> createState() => TvItemListState();
}

class TvItemListState extends State<TvItemList> {
  controller.TvState _state = controller.TvState.disconect;
  Future<void> connect() async {
    setState(() {
      _state = controller.TvState.connecting;
    });
    final newState = await widget.connect();
    setState(() {
      _state = newState;
    });
  }

  @override
  Widget build(BuildContext context) => Card(
        elevation: 10,
        child: ListTile(
          leading: const Icon(Icons.tv),
          onTap: () => connect(),
          title: Text(
            widget.tvNetworkInfo.name,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.merge(const TextStyle(fontWeight: FontWeight.bold)),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'IPv4: ${widget.tvNetworkInfo.ip}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                'MAC: ${widget.tvNetworkInfo.mac}',
                style: Theme.of(context).textTheme.bodySmall,
              )
            ],
          ),
          trailing: tvStatus(context),
        ),
      );

  Widget? tvStatus(BuildContext context) {
    switch (_state) {
      case controller.TvState.connected:
        return Text('Connected', style: Theme.of(context).textTheme.bodySmall);
      case controller.TvState.disconect:
        return null;
      case controller.TvState.connecting:
        return const CircularProgressIndicator();
    }
  }
}
