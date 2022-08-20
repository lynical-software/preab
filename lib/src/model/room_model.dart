import '../../preab.dart';

extension RoomX on RoomModel {
  String get roomName {
    return users.firstWhere((element) => element.id != PreabClient.profileId).id;
  }

  PreabProfile get otherUser {
    return users.firstWhere((element) => element.id != PreabClient.profileId);
  }
}

class RoomModel {
  RoomModel({
    required this.id,
    required this.name,
    required this.users,
    required this.lastMessage,
    this.updated,
    this.created,
  });

  final String id;
  final String name;
  final DateTime? updated;
  final DateTime? created;
  final List<PreabProfile> users;
  final String? lastMessage;

  RoomModel copyWith({
    String? id,
    String? name,
    String? lastMessage,
    DateTime? updated,
    DateTime? created,
    List<PreabProfile>? users,
  }) {
    return RoomModel(
      id: id ?? this.id,
      name: name ?? this.name,
      updated: updated ?? this.updated,
      created: created ?? this.created,
      users: users ?? this.users,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      updated: json["updated"] == null ? null : DateTime.parse(json["updated"]),
      created: json["created"] == null ? null : DateTime.parse(json["created"]),
      users: json["@expand"]['users'] == null
          ? []
          : List<PreabProfile>.from(
              json["@expand"]['users'].map(
                (x) => PreabProfile.fromJson(x),
              ),
            ),
      lastMessage: json['last_message'] ?? "",
    );
  }

  @override
  String toString() {
    return '$id, $name, $updated, $created, $users';
  }
}
