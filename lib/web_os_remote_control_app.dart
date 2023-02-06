import 'package:flutter/material.dart';
import 'package:web_os_control/remote_control_page/remote_control_page.dart';

class WebOsRemoteControlApp extends StatelessWidget {
  WebOsRemoteControlApp({super.key});
  @override
  Widget build(BuildContext context) {
    const m3 = true;
    return MaterialApp(
      themeMode: ThemeMode.dark,
      home: RemoteControlPage(),
      theme: ThemeData(
        useMaterial3: m3,
      ),
      darkTheme: ThemeData.dark(useMaterial3: m3),
    );
  }
}
