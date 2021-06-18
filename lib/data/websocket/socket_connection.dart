import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

typedef OnConnectedFunction = void Function();
typedef OnDisconnectedFunction = void Function();
typedef OnMessageFunction = void Function(Map message);

class SocketConnection {
  final String url;
  final Duration pingInterval;

  late Timer _timer;
  late WebSocketChannel _channel;
  late StreamSubscription _listener;

  DateTime? _lastPing;
  bool _isConnected = false;

  OnConnectedFunction? _onConnected;
  OnDisconnectedFunction? _onDisconnected;
  OnMessageFunction? _onMessage;

  SocketConnection(
    String url, {
    Map<String, String> params = const {},
    Duration pingInterval = const Duration(seconds: 3),
  })  : this.url = url + "?" + Uri(queryParameters: params).query,
        this.pingInterval = pingInterval;

  void connect() {
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _listener = _channel.stream.listen(_onData, onError: _close);
    _timer = Timer.periodic(pingInterval, _healthCheck);
  }

  void disconnect() {
    _close(null);
  }

  void emit(Map payload) {
    if (_isConnected) {
      _channel.sink.add(jsonEncode(payload));
    }
  }

  void _onData(dynamic data) {
    data = jsonDecode(data);

    switch (data["type"]) {
      case "ping":
        // Rails sends epoch as seconds, not miliseconds
        _lastPing = DateTime.fromMillisecondsSinceEpoch(data['message'] * 1000);
        break;
      case 'welcome':
        _isConnected = true;
        _onConnected?.call();
        break;
      default:
        _onMessage?.call(data);
    }
  }

  void _healthCheck(_) {
    if (_lastPing == null) return;
    if (DateTime.now().difference(_lastPing!) > Duration(seconds: 6)) {
      _close("Health check failed");
    }
  }

  void _close(dynamic error) {
    _timer.cancel();
    _channel.sink.close();
    _listener.cancel();
    _onDisconnected?.call();
    _isConnected = false;

    // if (error != null) {
    //   connect();
    // }
  }

  void onConnect(OnConnectedFunction onConnected) {
    _onConnected = onConnected;
  }

  void onDisconnect(OnDisconnectedFunction onDisconnected) {
    _onDisconnected = onDisconnected;
  }

  void onData(OnMessageFunction onMessage) {
    _onMessage = onMessage;
  }
}
