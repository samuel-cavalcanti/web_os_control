import 'dart:async';
import 'dart:isolate';

import 'package:web_os/web_os_client_api/web_os_client_api.dart';

import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:web_os/web_os_bindings_generated.dart';

SendPort singleMessage<T>(Completer<T> comp) {
  final recv = ReceivePort();

  onData(data) {
    recv.close();
    try {
      comp.complete(data);
    } catch (error, stack) {
      comp.completeError(error, stack);
    }
  }

  recv.listen(onData);

  return recv.sendPort;
}

(SendPort, Future<bool>) singleBooleanMessage() {
  final com = Completer<bool>();

  return (singleMessage(com), com.future);
}

extension ToPointer on WebOsTV {
  Pointer<WebOsNetworkInfoFFI> toPointer() {
    final infoPointer = malloc.allocate<WebOsNetworkInfoFFI>(1);

    infoPointer.ref.mac = mac.toNativeUtf8().cast<Char>();
    infoPointer.ref.ip = ip.toNativeUtf8().cast<Char>();
    infoPointer.ref.name = name.toNativeUtf8().cast<Char>();

    return infoPointer;
  }
}
