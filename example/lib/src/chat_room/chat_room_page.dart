import 'dart:io';

import 'package:flutter/material.dart';
import 'package:future_manager/future_manager.dart';
import 'package:preab/preab.dart';
import 'package:preab_example/src/chat_room/widgets/message_tile.dart';
import 'package:preab_example/src/home/home.dart';
import 'package:sura_flutter/sura_flutter.dart';

import 'widgets/message_composer.dart';

class ChatRoom extends StatefulWidget {
  final RoomModel room;
  const ChatRoom({Key? key, required this.room}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> with ManagerProviderMixin {
  FutureManager<List<ChatMessageModel>> messageManager = FutureManager();

  String get roomId => widget.room.id;
  late PreabMessageService preabMessage = PreabMessageService(roomId);
  late RoomModel roomModel;

  final TextEditingController messageTC = TextEditingController();

  void onSendMessage(File? file) async {
    try {
      String msg = messageTC.text.trim();
      if (msg.isEmpty && file == null) {
        return;
      }
      messageTC.clear();
      await preabMessage.sendMessage(msg, attachment: file);
      roomController.roomManager.refresh();
    } catch (ex) {
      errorLog(ex);
    }
  }

  void fetchAndListen() async {
    await messageManager.execute(() async {
      roomModel = await PreabRoomService.instance.getOneRoom(roomId);
      return preabMessage.getInitialMessage();
    });
    preabMessage.listen((message) {
      if (!message.isMyMessage) {
        roomController.roomManager.refresh();
      }
      var data = messageManager.data ?? [];
      data.insert(0, message);
      messageManager.updateData(data);
    });
  }

  @override
  void initState() {
    fetchAndListen();
    super.initState();
  }

  @override
  void dispose() {
    messageTC.dispose();
    preabMessage.dispose();
    messageManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.room.roomName),
      ),
      body: Column(
        children: [
          Expanded(
            child: messageManager.when(
              ready: (messages) {
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return MessageTile(
                      message: messages[index],
                      room: roomModel,
                    );
                  },
                );
              },
            ),
          ),
          MessageComposer(
            textEditingController: messageTC,
            onSend: onSendMessage,
          ),
        ],
      ),
    );
  }
}
