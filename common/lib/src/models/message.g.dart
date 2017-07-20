// GENERATED CODE - DO NOT MODIFY BY HAND

part of common.models.message;

// **************************************************************************
// Generator: JsonModelGenerator
// Target: class _Message
// **************************************************************************

class Message extends _Message {
  @override
  String id;

  @override
  String userId;

  @override
  String text;

  @override
  DateTime createdAt;

  @override
  DateTime updatedAt;

  Message({this.id, this.userId, this.text, this.createdAt, this.updatedAt});

  factory Message.fromJson(Map data) {
    return new Message(
        id: data['id'],
        userId: data['user_id'],
        text: data['text'],
        createdAt: data['created_at'] is DateTime
            ? data['created_at']
            : (data['created_at'] is String
                ? DateTime.parse(data['created_at'])
                : null),
        updatedAt: data['updated_at'] is DateTime
            ? data['updated_at']
            : (data['updated_at'] is String
                ? DateTime.parse(data['updated_at'])
                : null));
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'text': text,
        'created_at': createdAt == null ? null : createdAt.toIso8601String(),
        'updated_at': updatedAt == null ? null : updatedAt.toIso8601String()
      };

  static Message parse(Map map) => new Message.fromJson(map);
}
