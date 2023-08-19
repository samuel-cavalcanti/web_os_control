import 'package:flutter/material.dart';
import 'package:web_os_control/controllers/web_os_network_controller.dart';

class ConnectPageTitle extends StatelessWidget {
  final DiscoveryState state;
  const ConnectPageTitle({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case DiscoveryState.searching:
        return _visibleTvsLoading(context);

      case DiscoveryState.finished:
        return _visibleTvs(context);
    }
  }

  Widget _visibleTvs(BuildContext context) => Text(
        'Visible TVs',
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.merge(const TextStyle(fontWeight: FontWeight.bold)),
      );

  Widget _visibleTvsLoading(BuildContext context) => Row(children: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: _visibleTvs(context),
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
