import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:guardspot/app/config/network_config.dart';
import 'package:guardspot/data/user/user_store.dart';
import 'package:guardspot/data/websocket/socket_connection.dart';
import 'package:guardspot/data/websocket/socket_event.dart';
import 'package:guardspot/data/websocket/socket_response.dart';
import 'package:guardspot/data/websocket/channel_identifier.dart';
import 'package:guardspot/data/websocket/update_message.dart';
import 'package:rxdart/rxdart.dart';

@lazySingleton
class SocketService {
  final UserStore _userStore;
  final Map<ChannelIdentifier, List<StreamController>> _subscribers = {};

  SocketConnection? _connection;

  SocketService(this._userStore) {
    _userStore.observeAuthState().listen(_updateSocketInstance);
  }

  void _updateSocketInstance(bool isSignedIn) {
    if (isSignedIn) {
      final params = {"token": _userStore.getAuthenticationToken()!};
      _connect(params: params);
    } else {
      _connection?.disconnect();
    }
  }

  void _connect({Map<String, String> params = const {}}) {
    _connection = SocketConnection(NetworkConfig.WS_ENDPOINT, params: params);
    _connection?.connect();
    _connection?.onData(_onData);
    _connection?.onDisconnect(() => Fimber.d("Socket disconnected"));
    _connection?.onConnect(() {
      Fimber.d("Socket connected");

      // Resubscribe to all channels that have an active subscriber
      _subscribers.keys.forEach((it) {
        final list = _subscribers[it];
        if (list != null && list.isNotEmpty)
          _connection?.emit({
            "command": "subscribe",
            "identifier": it.encode(),
          });
      });
    });
  }

  Stream<SocketEvent> subscribe({
    required String channel,
    int? modelId,
    ModelType? modelType,
  }) {
    final controller = StreamController<SocketEvent>();
    final identifier = ChannelIdentifier(channel, modelId: modelId);

    _subscribe(controller, identifier);

    return controller.stream
        .where((it) =>
            it is OnSubscriptionConfirmed ||
            it is OnSubscriptionRejected ||
            it is OnDataReceived && it.belongsTo(modelType))
        .doOnCancel(() => _unsubscribe(controller, identifier));
  }

  void _subscribe(
    StreamController controller,
    ChannelIdentifier identifier,
  ) {
    if (_subscribers[identifier] == null) {
      _subscribers[identifier] = [];
      _connection?.emit({
        "command": "subscribe",
        "identifier": identifier.encode(),
      });
    } else {
      controller.add(OnSubscriptionConfirmed());
    }

    _subscribers[identifier]?.add(controller);
  }

  void _unsubscribe(
    StreamController controller,
    ChannelIdentifier identifier,
  ) {
    _subscribers[identifier]?.remove(controller);
    controller.close();

    if (_subscribers[identifier]!.isEmpty) {
      _subscribers.remove(identifier);
      _connection
          ?.emit({"command": "unsubscribe", "identifier": identifier.encode()});
    }
  }

  void _onData(Map data) {
    final identifier = ChannelIdentifier.parse(data["identifier"]);
    final controllers = _subscribers[identifier];

    switch (data["type"]) {
      case "confirm_subscription":
        controllers?.forEach((it) => it.add(OnSubscriptionConfirmed()));
        break;
      case "reject_subscription":
        controllers?.forEach((it) => it.add(OnSubscriptionRejected()));
        break;
      default:
        final message = OnDataReceived(
          SocketResponse.fromJson(data as Map<String, dynamic>),
        );
        controllers?.forEach((it) => it.add(message));
    }
  }
}
