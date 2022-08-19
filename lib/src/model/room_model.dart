import 'package:pocketbase/pocketbase.dart';
import 'package:preab/src/services/preab_auth.dart';

extension RoomX on RoomModel {
  String get roomName {
    return users.firstWhere((element) => element.id != PreabAuth.me).id;
  }
}

class RoomModel {
  RoomModel({
    required this.id,
    required this.name,
    required this.users,
    this.updated,
    this.created,
  });

  final String id;
  final String name;
  final DateTime? updated;
  final DateTime? created;
  final List<RecordModel> users;

  RoomModel copyWith({
    String? id,
    String? name,
    DateTime? updated,
    DateTime? created,
    List<RecordModel>? users,
  }) {
    return RoomModel(
      id: id ?? this.id,
      name: name ?? this.name,
      updated: updated ?? this.updated,
      created: created ?? this.created,
      users: users ?? this.users,
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
          : List<RecordModel>.from(
              json["@expand"]['users'].map(
                (x) => RecordModel.fromJson(x),
              ),
            ),
    );
  }

  @override
  String toString() {
    return '$id, $name, $updated, $created, $users';
  }
}
