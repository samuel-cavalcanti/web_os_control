class WebOsNetworkInfo {
  final String ip;
  final String mac;
  final String name;

  const WebOsNetworkInfo(
      {required this.ip, required this.mac, required this.name});

  @override
  String toString() {
    return '''WebOsNetworkInfo{
        name:$name,
        mac:$mac,
        ip:$ip,
    }
        ''';
  }
}

abstract interface class WebOsNetworkAPI {
  Future<List<WebOsNetworkInfo>> discoveryTv();
  Future<bool> connectToTV(WebOsNetworkInfo info);
  Future<WebOsNetworkInfo?> loadLastTvInfo();
  Future<bool> turnOnTV(WebOsNetworkInfo info);
}
