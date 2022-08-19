class RoomModel {
  RoomModel({
    required this.id,
    required this.name,
    this.updated,
    this.created,
    required this.users,
  });

  final String id;
  final String name;
  final DateTime? updated;
  final DateTime? created;
  final List<String> users;

  RoomModel copyWith({
    String? id,
    String? name,
    DateTime? updated,
    DateTime? created,
    List<String>? users,
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
      users: json["users"] == null ? [] : List<String>.from(json["users"]!.map((x) => x)),
    );
  }

  @override
  String toString() {
    return '$id, $name, $updated, $created, $users';
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "users": List<String>.from(users.map((x) => x)),
      };
}
