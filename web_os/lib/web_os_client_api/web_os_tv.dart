
class WebOsTV {
  final String ip;
  final String mac;
  final String name;

  const WebOsTV({required this.ip, required this.mac, required this.name});

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
