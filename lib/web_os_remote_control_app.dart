import 'package:flutter/material.dart';

import 'web_os_control_routers.dart' as web_os_control_routers;

class WebOsRemoteControlApp extends StatelessWidget {
  const WebOsRemoteControlApp({super.key});
  @override
  Widget build(BuildContext context) {
    const m3 = true;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: web_os_control_routers.routers,
      initialRoute: web_os_control_routers.connectToTVPage,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        useMaterial3: m3,
      ),
      darkTheme: ThemeData.dark(useMaterial3: m3).copyWith(),
    );
  }
}
