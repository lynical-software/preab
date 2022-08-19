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
      filter: 'users ~ "${PreabAuth.me}"',
      page: page,
      perPage: limit,
      query: {
        "expand": "users",
      },
    );
    List data = response.items.map((e) => e.toJson()).toList();
    return data.map((e) => RoomModel.fromJson(e)).toList();
  }

  Future<RoomModel> createRoom(String roomName, String otherId) async {
    var record = await PreabClient.client.records.create(
      roomCollection,
      body: {
        "name": roomName,
        "users": [
          PreabAuth.me,
          otherId,
        ],
      },
    );
    return RoomModel.fromJson(record.toJson());
  }

  Future<RoomModel> getOneRoom(String roomId) async {
    var record = await PreabClient.client.records.getOne(
      roomCollection,
      roomId,
      query: {
        "expand": "users",
      },
    );
    return RoomModel.fromJson(record.toJson());
  }
}
