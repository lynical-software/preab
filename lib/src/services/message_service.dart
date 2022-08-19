import 'package:pocketbase/pocketbase.dart';
import 'package:preab/preab.dart';
import 'package:preab/src/constant/collection_name.dart';
import 'package:preab/src/services/preab_auth.dart';

class PreabMessage {
  final String roomId;
  PreabMessage(this.roomId);

  Future<List<ChatMessageModel>> getInitialMessage() async {
    var response = await PreabClient.client.records.getList(
      "messages",
      filter: 'room = "$roomId"',
      sort: "-created",
    );
    List data = response.items.map((e) => e.toJson()).toList();
    return data.map((e) => ChatMessageModel.fromJson(e)).toList();
  }

  void listen(void Function(ChatMessageModel) onData) {
    PreabClient.client.realtime.subscribe(messageCollection, (e) {
      if (e.record != null) {
        if (e.record!.getStringValue("room") == roomId) {
          ChatMessageModel messageModel = ChatMessageModel.fromJson(e.record!.toJson());
          onData.call(messageModel);
        }
      }
    });
  }

  Future<ChatMessageModel> sendMessage(String message) async {
    RoomModel roomModel = await PreabRoom.instance.getOneRoom(roomId);
    RecordModel receiver = roomModel.users.firstWhere((element) => element.id != PreabAuth.me);

    var record = await PreabClient.client.records.create(
      messageCollection,
      body: ChatMessageModel(
        id: "id",
        message: message,
        receiver: receiver.id,
        room: roomId,
        sender: PreabAuth.me,
      ).toJson(),
    );
    return ChatMessageModel.fromJson(record.toJson());
  }

  void dispose() {
    PreabClient.client.realtime.unsubscribe(messageCollection);
  }
}
