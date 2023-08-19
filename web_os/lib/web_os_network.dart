import 'dart:async';
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:web_os/web_os_bindings_api.dart';
import 'package:web_os/web_os_bindings_generated.dart';
import 'package:web_os/web_os_client_api/web_os_client_api.dart';
import 'utils.dart' as utils;

class WebOsNetwork implements WebOsNetworkAPI {
  final WebOsBindingsAPI _bindings;

  WebOsNetwork(this._bindings);

  @override
  Future<bool> connectToTV(WebOsTV info) {
    final completer = Completer<bool>();
    final sendPort = utils.singleMessage(completer);

    final infoPointer = _allocateInfoFFI(info);
    _bindings.connectToTV(infoPointer.ref, sendPort);
    final future = completer.future;

    return future;
  }

  @override
  Future<List<WebOsTV>> discoveryTv() async {
    debugPrint("Discovery");

    final completer = Completer<List<dynamic>>();

    final sendPort = utils.singleMessage(completer);

    _bindings.discoveryBySSDP(sendPort);

    final data = await completer.future;
    final infos = data
        .map((info) =>
            WebOsTV(ip: info[0], name: info[1], mac: info[2]))
        .toList(growable: false);

    debugPrint("completed $data");

    return infos;
  }

  @override
  Future<WebOsTV?> loadLastTvInfo() {
    final completer = Completer<List<dynamic>?>();
    final sendPort = utils.singleMessage(completer);
    _bindings.loadLastTvInfo(sendPort);

    future() async {
      final info = await completer.future;

      if (info.runtimeType == List) {
        return WebOsTV(ip: info![0], name: info[1], mac: info[2]);
      }

      return null;
    }

    return future();
  }

  @override
  Future<bool> turnOnTV(WebOsTV info) {
    final infoPointer = _allocateInfoFFI(info);
    final (port, future) = utils.singleBooleanMessage();
    _bindings.turnOn(infoPointer.ref, port);
    return future;
  }

  Pointer<WebOsNetworkInfoFFI> _allocateInfoFFI(WebOsTV info) {
    final infoPointer = malloc.allocate<WebOsNetworkInfoFFI>(1);

    infoPointer.ref.mac = info.mac.toNativeUtf8().cast<Char>();
    infoPointer.ref.ip = info.ip.toNativeUtf8().cast<Char>();
    infoPointer.ref.name = info.name.toNativeUtf8().cast<Char>();

    return infoPointer;
  }
}
