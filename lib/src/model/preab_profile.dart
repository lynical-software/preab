class PreabProfile {
  PreabProfile({
    required this.avatar,
    required this.created,
    required this.id,
    required this.name,
    required this.updated,
    required this.userId,
  });

  final String avatar;
  final DateTime? created;
  final String id;
  final String name;
  final DateTime? updated;
  final String userId;

  PreabProfile copyWith({
    String? avatar,
    DateTime? created,
    String? id,
    String? name,
    DateTime? updated,
    String? userId,
  }) {
    return PreabProfile(
      avatar: avatar ?? this.avatar,
      created: created ?? this.created,
      id: id ?? this.id,
      name: name ?? this.name,
      updated: updated ?? this.updated,
      userId: userId ?? this.userId,
    );
  }

  factory PreabProfile.fromJson(Map<String, dynamic> json) {
    return PreabProfile(
      avatar: json["avatar"] ?? "",
      created: json["created"] == null ? null : DateTime.parse(json["created"]),
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      updated: json["updated"] == null ? null : DateTime.parse(json["updated"]),
      userId: json["userId"] ?? "",
    );
  }

  @override
  String toString() {
    return '$avatar, $created, $id, $name, $updated, $userId';
  }

  Map<String, dynamic> toJson() => {
        "avatar": avatar,
        "created": created?.toIso8601String(),
        "id": id,
        "name": name,
        "updated": updated?.toIso8601String(),
        "userId": userId,
      };
}
