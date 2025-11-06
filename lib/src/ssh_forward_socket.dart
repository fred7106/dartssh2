import 'dart:convert';
import 'package:dartssh2/dartssh2.dart';

/// Wrapper socket for forwarding via SSH
class SSHForwardSocket {
  final SSHForwardChannel _channel;

  SSHForwardSocket(this._channel);

  /// Stream of received  byte
  Stream<List<int>> get stream => _channel.stream;

  /// Write  data into the  channel
  void write(String data) {
    _channel.sink.add(utf8.encode(data));
  }

  /// Cloese la connection
  Future<void> close() async {
    await _channel.sink.close();
  }
}

/// Extention to create a forward tunnel as socket
extension SSHForwardSocketExtension on SSHClient {
  Future<SSHForwardSocket> forwardSocket(String host, int port) async {
    final channel = await forwardLocal(host, port);
    return SSHForwardSocket(channel);
  }
}
