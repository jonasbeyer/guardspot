import 'package:guardspot/data/websocket/socket_response.dart';
import 'package:guardspot/data/websocket/update_message.dart';

abstract class SocketEvent {}

class OnSubscriptionConfirmed extends SocketEvent {}

class OnSubscriptionRejected extends SocketEvent {}

class OnDataReceived<T> extends SocketEvent {
  final SocketResponse<T> data;

  bool belongsTo(ModelType? modelType) =>
      modelType == null || data.message.typeName == modelType;

  OnDataReceived(this.data);
}
