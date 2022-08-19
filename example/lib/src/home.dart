import 'package:flutter/material.dart';
import 'package:future_manager/future_manager.dart';
import 'package:preab/preab.dart';
import 'package:preab_example/src/chat_room.dart';
import 'package:preab_example/src/init.dart';
import 'package:preab_example/src/sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      await init();
      return PreabRoom.instance.getAllRooms();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preab App"),
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
                    data[index].roomName.characters.first.toUpperCase(),
                  ),
                ),
                title: Text(data[index].roomName),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await PreabRoom.instance.createRoom("chunlee2", "u0e72t6hs9rZTDb");
          roomManager.refresh();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
