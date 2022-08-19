import 'package:flutter/material.dart';
import 'package:future_manager/future_manager.dart';
import 'package:preab/preab.dart';
import 'package:preab_example/src/chat_room.dart';
import 'package:sura_flutter/sura_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FutureManager<List<RoomModel>> roomManager = FutureManager();

  @override
  void initState() {
    roomManager.execute(() async {
      return PreabRoom.instance.getAllRooms();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Preab App")),
      body: roomManager.when(
        ready: (data) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                onTap: () {
                  SuraPageNavigator.push(context, ChatRoom(room: data[index]));
                },
                leading: CircleAvatar(
                  child: Text(
                    data[index].name.characters.first.toUpperCase(),
                  ),
                ),
                title: Text(data[index].name),
              );
            },
          );
        },
      ),
    );
  }
}
