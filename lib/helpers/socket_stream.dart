import 'dart:async';

class SocketStream {
  final _socketResponse = StreamController<List>();

  void Function(List) get addResponse => _socketResponse.sink.add;

  Stream<List> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}
