import 'package:flutter/material.dart';
import 'package:web_os/web_os_client_api/web_os_network_api.dart';
import 'package:web_os_control/controllers/web_os_network_controller.dart';

class TvItemList extends StatefulWidget {
  final WebOsTV tvNetworkInfo;
  final Future<TvState> Function() connect;
  const TvItemList(
      {super.key, required this.tvNetworkInfo, required this.connect});

  @override
  State<StatefulWidget> createState() => TvItemListState();
}

class TvItemListState extends State<TvItemList> {
  TvState _state = TvState.disconect;
  Future<void> connect() async {
    setState(() {
      _state = TvState.connecting;
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
      case TvState.connected:
        return Text('Connected', style: Theme.of(context).textTheme.bodySmall);
      case TvState.disconect:
        return null;
      case TvState.connecting:
        return const CircularProgressIndicator();
    }
  }
}
