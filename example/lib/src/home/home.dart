import 'package:flutter/material.dart';
import 'package:future_manager/future_manager.dart';
import 'package:preab/preab.dart';
import 'package:preab_example/src/auth/init.dart';
import 'package:preab_example/src/auth/sign_in.dart';
import 'package:preab_example/src/chat_room/chat_room_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sura_flutter/sura_flutter.dart';

class RoomController {
  final roomManager = FutureManager<List<RoomModel>>(
    futureFunction: () async {
      await init();
      return PreabRoom.instance.getAllRooms();
    },
  );
}

final roomController = RoomController();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text("Preab App"),
            roomController.roomManager.listen(ready: (_) => Text(": ${PreabClient.profileId}")),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              SharedPreferences.getInstance().then((value) => value.clear());
              SuraPageNavigator.pushAndRemove(context, const SignInPage());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: roomController.roomManager.when(
        ready: (rooms) {
          return ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (BuildContext context, int index) {
              final room = rooms[index];
              return ListTile(
                onTap: () {
                  SuraPageNavigator.push(context, ChatRoom(room: room));
                },
                leading: CircleAvatar(
                  child: Text(
                    room.roomName.characters.first.toUpperCase(),
                  ),
                ),
                title: Text(room.roomName),
                subtitle: EllipsisText(room.lastMessage),
              );
            },
          );
        },
      ),
      floatingActionButton: SuraAsyncIconButton(
        backgroundColor: Colors.blue,
        borderRadius: 32,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(16),
        onTap: () async {
          await PreabRoom.instance.createRoom("room1", "0War2IBvh13joKu");
          roomController.roomManager.refresh();
        },
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
