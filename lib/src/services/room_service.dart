import 'package:pocketbase/pocketbase.dart';
import 'package:preab/preab.dart';
import 'package:preab/src/constant/collection_name.dart';

import 'preab_auth.dart';

class PreabRoom {
  PreabRoom._privateConstructor();

  static final PreabRoom instance = PreabRoom._privateConstructor();

  Future<List<RoomModel>> getAllRooms({
    int page = 1,
    int limit = 9999999,
  }) async {
    var response = await PreabClient.client.records.getList(
      "rooms",
      filter: 'users ~ "${PreabAuth.me.id}"',
      page: page,
      perPage: limit,
    );
    List data = response.items.map((e) => e.toJson()).toList();
    return data.map((e) => RoomModel.fromJson(e)).toList();
  }

  Future<RoomModel> createRoom(String roomName, UserModel otherUser) async {
    var record = await PreabClient.client.records.create(
      roomCollection,
      body: RoomModel(
        id: "",
        name: roomName,
        users: [
          PreabAuth.me.id,
          otherUser.id,
        ],
      ).toJson(),
    );
    return RoomModel.fromJson(record.toJson());
  }
}
