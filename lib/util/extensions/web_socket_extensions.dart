import 'package:guardspot/data/websocket/socket_event.dart';
import 'package:guardspot/data/websocket/update_message.dart';
import 'package:guardspot/models/model.dart';

extension WebSocketAccumulatorExtension on Stream<SocketEvent> {
  Stream<List<T>> accumulate<T extends Model>({
    required Future<List<T>> Function() initialSnapshot,
  }) {
    late List<T> list;
    return asyncMap((event) async {
      if (event is OnSubscriptionConfirmed) list = await initialSnapshot();
      if (event is OnDataReceived)
        list = list.merge(event.data.message.typedAs<T>());

      return list;
    });
  }
}

extension WebSocketMergeExtensions<T extends Model> on List<T> {
  List<T> merge(UpdateMessage<T> response) {
    int modelId = response.data.id!;
    ModelEvent changeType = response.event;

    switch (changeType) {
      case ModelEvent.ADD:
        insert(0, response.data);
        return this;
      case ModelEvent.UPDATE:
        return map((it) => it.id == modelId ? response.data : it).toList();
      case ModelEvent.REMOVE:
        removeWhere((it) => it.id == modelId);
        return this;
    }
  }
}
