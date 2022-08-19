import 'package:preab/preab.dart';
import 'package:preab/src/constant/collection_name.dart';

class PreabRoom {
  PreabRoom._privateConstructor();

  static final PreabRoom instance = PreabRoom._privateConstructor();

  Future<RoomModel?> checkIfRoomExist(String profileId) async {
    var response = await PreabClient.client.records.getList(
      "rooms",
      filter: 'users ~ "$profileId" && users ~ "${PreabClient.profileId}"',
    );
    return response.items.isNotEmpty ? RoomModel.fromJson(response.items.first.toJson()) : null;
  }

  Future<List<RoomModel>> getAllRooms({
    int page = 1,
    int limit = 9999999,
  }) async {
    var response = await PreabClient.client.records.getList(
      "rooms",
      filter: 'users ~ "${PreabClient.profileId}"',
      page: page,
      perPage: limit,
      query: {
        "expand": "users",
      },
      sort: "-updated",
    );
    List data = response.items.map((e) => e.toJson()).toList();
    return data.map((e) => RoomModel.fromJson(e)).toList();
  }

  Future<RoomModel> createRoom(String roomName, String otherId) async {
    RoomModel? exist = await checkIfRoomExist(otherId);
    if (exist != null) {
      return exist;
    }
    var record = await PreabClient.client.records.create(
      roomCollection,
      body: {
        "name": roomName,
        "users": [
          PreabClient.profileId,
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
