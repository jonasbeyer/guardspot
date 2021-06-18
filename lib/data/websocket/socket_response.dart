import 'package:guardspot/data/websocket/channel_identifier.dart';
import 'package:guardspot/data/websocket/update_message.dart';

class SocketResponse<T> {
  final ChannelIdentifier identifier;
  final UpdateMessage<T> message;

  SocketResponse(this.identifier, this.message);

  factory SocketResponse.fromJson(Map<String, dynamic> json) {
    return SocketResponse(
      ChannelIdentifier.parse(json["identifier"]),
      UpdateMessage.fromJson(json["message"]),
    );
  }
}
