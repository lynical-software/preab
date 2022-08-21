import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:preab/preab.dart';
import 'package:preab/src/constant/collection_name.dart';

class PreabMessageService {
  final String roomId;
  PreabMessageService(this.roomId);

  Future<List<ChatMessageModel>> getInitialMessage() async {
    var response = await PreabClient.client.records.getList(
      "messages",
      filter: 'room = "$roomId"',
      query: {
        "expand": "attachment",
      },
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

  Future<ChatMessageModel> sendMessage(String message, {File? attachment}) async {
    RoomModel roomModel = await PreabRoomService.instance.getOneRoom(roomId);
    PreabProfile receiver = roomModel.users.firstWhere((element) => element.id != PreabClient.profileId);
    String? fileName;
    if (attachment != null) {
      fileName = attachment.path.split("/").last;
    }

    final messageModel = ChatMessageModel(
      id: "id",
      message: message,
      receiver: receiver.id,
      room: roomId,
      sender: PreabClient.profileId,
    );
    var record = await PreabClient.client.records.create(
      messageCollection,
      body: messageModel.toJson(),
      files: [
        if (attachment != null)
          await http.MultipartFile.fromPath(
            'attachment',
            attachment.path,
            filename: fileName,
          ),
      ],
    );
    _updateLastMessage(message);
    return ChatMessageModel.fromJson(record.toJson());
  }

  Future _updateLastMessage(String lastMessage) async {
    await PreabClient.client.records.update(
      roomCollection,
      roomId,
      body: {
        "last_message": lastMessage.isEmpty ? "Photo" : lastMessage,
      },
    );
  }

  void dispose() {
    PreabClient.client.realtime.unsubscribe(messageCollection);
  }
}
