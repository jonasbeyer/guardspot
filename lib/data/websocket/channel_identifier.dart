import 'dart:collection';
import 'dart:convert';

class ChannelIdentifier {
  final String channel;
  final int? modelId;

  ChannelIdentifier(this.channel, {this.modelId});

  factory ChannelIdentifier.parse(String channelId) {
    Map map = SplayTreeMap.from(jsonDecode(channelId));
    return ChannelIdentifier(
      map['channel'] as String,
      modelId: map['modelId'] as int?,
    );
  }

  String encode() {
    Map map = {"channel": channel};
    if (modelId != null) {
      map["modelId"] = modelId;
    }

    return jsonEncode(SplayTreeMap.from(map));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChannelIdentifier &&
          channel == other.channel &&
          modelId == other.modelId;

  @override
  int get hashCode => channel.hashCode + (modelId?.hashCode ?? 0);
}
