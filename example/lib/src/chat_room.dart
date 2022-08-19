import 'dart:io';

import 'package:flutter/material.dart';
import 'package:future_manager/future_manager.dart';
import 'package:preab/preab.dart';
import 'package:sura_flutter/sura_flutter.dart';

class ChatRoom extends StatefulWidget {
  final RoomModel room;
  const ChatRoom({Key? key, required this.room}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  FutureManager<List<ChatMessageModel>> messageManager = FutureManager();

  String get roomId => widget.room.id;
  late PreabMessage preabMessage = PreabMessage(roomId);
  late RoomModel roomModel;

  @override
  void initState() {
    messageManager.execute(() async {
      roomModel = await PreabRoom.instance.getOneRoom(roomId);
      return preabMessage.getInitialMessage();
    }).then((value) {
      preabMessage.listen((message) {
        var data = messageManager.data!;
        data.insert(0, message);
        messageManager.updateData(data);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    preabMessage.dispose();
    messageManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(roomId)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: messageManager.when(
                ready: (messages) {
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(messages[index].message),
                        subtitle: EllipsisText(messages[index].created?.toIso8601String()),
                      );
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                preabMessage.sendMessage("Hi from ${Platform.operatingSystem}");
              },
              child: const Text("Send message"),
            ),
          ],
        ),
      ),
    );
  }
}
