class ChatMessageModel {
  ChatMessageModel({
    required this.id,
    required this.message,
    required this.receiver,
    required this.room,
    required this.sender,
    this.created,
    this.updated,
  });

  final DateTime? created;
  final String id;
  final String message;
  final String receiver;
  final String room;
  final String sender;
  final DateTime? updated;

  ChatMessageModel copyWith({
    DateTime? created,
    String? id,
    String? message,
    String? receiver,
    String? room,
    String? sender,
    DateTime? updated,
  }) {
    return ChatMessageModel(
      created: created ?? this.created,
      id: id ?? this.id,
      message: message ?? this.message,
      receiver: receiver ?? this.receiver,
      room: room ?? this.room,
      sender: sender ?? this.sender,
      updated: updated ?? this.updated,
    );
  }

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      created: json["created"] == null ? null : DateTime.parse(json["created"]),
      id: json["id"] ?? "",
      message: json["message"] ?? "",
      receiver: json["receiver"] ?? "",
      room: json["room"] ?? "",
      sender: json["sender"] ?? "",
      updated: json["updated"] == null ? null : DateTime.parse(json["updated"]),
    );
  }

  @override
  String toString() {
    return '$created, $id, $message, $receiver, $room, $sender, $updated';
  }

  Map<String, dynamic> toJson() => {
        "message": message,
        "receiver": receiver,
        "room": room,
        "sender": sender,
      };
}
