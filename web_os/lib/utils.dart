import 'dart:async';
import 'dart:isolate';

SendPort singleMessage<T>(Completer<T> comp) {
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

(SendPort, Future<bool>) singleBooleanMessage() {
  final com = Completer<bool>();

  return (singleMessage(com), com.future);
}
