import 'package:flutter/material.dart';
import 'package:future_manager/future_manager.dart';
import 'package:preab/preab.dart';
import 'package:preab_example/src/chat_room/chat_room_page.dart';
import 'package:preab_example/src/home/home.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../widgets/profile_avatar.dart';

class SearchUserPage extends StatefulWidget {
  const SearchUserPage({Key? key}) : super(key: key);

  @override
  State<SearchUserPage> createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  TextEditingController usernameTC = TextEditingController();

  FutureManager<List<PreabProfile>> resultManager = FutureManager();

  void onSearch() async {
    try {
      String username = usernameTC.text.trim();
      if (username.isEmpty) {
        throw "Please input username";
      }
      await resultManager.resetData();
      var users = await PreabProfileService.instance.searchUser(username);
      if (users.isEmpty) {
        resultManager.addError("User not found! 😥");
      } else {
        resultManager.updateData(users);
      }
    } catch (e) {
      resultManager.addError(e);
      showSuraSimpleDialog(context, e.toString());
    }
  }

  @override
  void initState() {
    resultManager.addError("Type a username to search 🔍");
    super.initState();
  }

  @override
  void dispose() {
    resultManager.dispose();
    usernameTC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
      ),
      body: KeyboardDismiss(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: usernameTC,
                onSubmitted: (value) => onSearch(),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: "username",
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: SuraDecoration.radius(24),
                  ),
                  suffixIcon: IconButton(
                    onPressed: onSearch,
                    icon: const Icon(Icons.search),
                  ),
                ),
              ),
            ),
            const Divider(),
            resultManager.when(
              error: (err) {
                return _buildTextContainer(err.toString());
              },
              ready: (users) {
                return Column(
                  children: [
                    for (var user in users)
                      ListTile(
                        leading: ProfileAvatar(user: user),
                        title: Text(user.name),
                        subtitle: Text(user.id),
                        onTap: () async {
                          var rooms = roomController.roomManager.data!
                              .filter((element) => element.userIdList.contains(user.id));

                          if (rooms.isEmpty) {
                            RoomModel room = await PreabRoomService.instance.createRoom(user.id, user.id);
                            SuraPageNavigator.push(context, ChatRoom(room: room));
                            roomController.roomManager.refresh();
                          } else {
                            SuraPageNavigator.push(context, ChatRoom(room: rooms.first));
                          }
                        },
                      )
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextContainer(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32.0),
      alignment: Alignment.center,
      child: Text(
        text,
        style: context.textTheme.subtitle1,
      ),
    );
  }
}
