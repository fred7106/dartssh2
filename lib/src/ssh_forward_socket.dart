import 'dart:async';
import 'package:dartssh2/dartssh2.dart';

/// ===========================================================
///  Classe SSHForwardSocket: usa un canale SSH come socket TCP
/// ===========================================================
class SSHForwardSocket {
  final SSHForwardChannel _channel;
  final StreamController<List<int>> _controller = StreamController();

  SSHForwardSocket(this._channel) {
    _channel.stream.listen(
      (data) {
        _controller.add(data);
      },
      onDone: () {
        _controller.close();
      },
    );
  }

  /// Stream dei dati ricevuti
  Stream<List<int>> get stream => _controller.stream;

  /// Invia dati binari
  void add(List<int> data) => _channel.sink.add(data);

  /// Invia una stringa
  void write(String message) => _channel.sink.add(message.codeUnits);

  /// Chiude il tunnel
  Future<void> close() async {
    await _channel.sink.close();
    await _controller.close();
  }
}
