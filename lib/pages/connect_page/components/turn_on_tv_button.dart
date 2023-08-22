import 'package:flutter/material.dart';

class TurnOnTVButton extends StatefulWidget {
  final Future<void> Function() onPress;
  const TurnOnTVButton({super.key, required this.onPress});

  @override
  State<StatefulWidget> createState() => TurnOnTVButtonState();
}

class TurnOnTVButtonState extends State<TurnOnTVButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    debugPrint("is loading: $_isLoading");
    if (!_isLoading) {
      return ElevatedButton(
        child: Text(
          'Turn on TV',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.merge(const TextStyle(fontWeight: FontWeight.bold)),
        ),
        onPressed: () async {
          setState(() {
            _isLoading = true;
          });

          await widget.onPress();
          setState(() {
            _isLoading = false;
          });
        },
      );
    } else {
      return const CircularProgressIndicator();
    }
  }
}
