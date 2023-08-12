import 'dart:async';
import 'dart:ffi';
import 'dart:isolate';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:web_os/web_os_bindings_api.dart';
import 'package:web_os/web_os_bindings_generated.dart';
import 'package:web_os/web_os_client_api/web_os_client_api.dart';

class WebOsNetwork implements WebOsNetworkAPI {
  final WebOsBindingsAPI _bindings;

  WebOsNetwork(this._bindings);

  @override
  Future<bool> connectToTV(WebOsNetworkInfo info) {
    final completer = Completer<bool>();
    final sendPort = _singleMessage(completer);

    final infoPointer = _allocateInfoFFI(info);
    _bindings.connectToTV(infoPointer.ref, sendPort);
    final future = completer.future;

    return future;
  }

  @override
  Future<List<WebOsNetworkInfo>> discoveryTv() async {
    debugPrint("Discovery");

    final completer = Completer<List<dynamic>>();

    final sendPort = _singleMessage(completer);

    _bindings.discoveryBySSDP(sendPort);

    final data = await completer.future;
    final infos = data
        .map((info) =>
            WebOsNetworkInfo(ip: info[0], name: info[1], mac: info[2]))
        .toList(growable: false);

    debugPrint("completed $data");

    return infos;
  }

  @override
  Future<WebOsNetworkInfo?> loadLastTvInfo() {
    final completer = Completer<List<dynamic>?>();
    final sendPort = _singleMessage(completer);
    _bindings.loadLastTvInfo(sendPort);

    future() async {
      final info = await completer.future;

      if (info.runtimeType == List) {
        return WebOsNetworkInfo(ip: info![0], name: info[1], mac: info[2]);
      }

      return null;
    }

    return future();
  }

  @override
  Future<bool> turnOnTV(WebOsNetworkInfo info) {
    final infoPointer = _allocateInfoFFI(info);
    final completer = Completer<bool>();
    final sendPort = _singleMessage(completer);

    _bindings.turnOn(infoPointer.ref, sendPort);
    final future = completer.future;
    return future;
  }

  Pointer<WebOsNetworkInfoFFI> _allocateInfoFFI(WebOsNetworkInfo info) {
    final infoPointer = malloc.allocate<WebOsNetworkInfoFFI>(1);

    infoPointer.ref.mac = info.mac.toNativeUtf8().cast<Char>();
    infoPointer.ref.ip = info.ip.toNativeUtf8().cast<Char>();
    infoPointer.ref.name = info.name.toNativeUtf8().cast<Char>();

    return infoPointer;
  }

  SendPort _singleMessage<T>(Completer<T> comp) {
    final recv = ReceivePort();

    onData(data) {
      recv.close();
      try {
        comp.complete(data as T);
      } catch (error, stack) {
        comp.completeError(error, stack);
      }
    }

    recv.listen(onData);

    return recv.sendPort;
  }
}