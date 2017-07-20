// GENERATED CODE - DO NOT MODIFY BY HAND

part of common.models;

// **************************************************************************
// Generator: JsonModelGenerator
// Target: class _User
// **************************************************************************

class User extends _User {
  @override
  String id;

  @override
  String username;

  @override
  String password;

  @override
  String salt;

  @override
  String avatar;

  @override
  DateTime createdAt;

  @override
  DateTime updatedAt;

  User(
      {this.id,
      this.username,
      this.password,
      this.salt,
      this.avatar,
      this.createdAt,
      this.updatedAt});

  factory User.fromJson(Map data) {
    return new User(
        id: data['id'],
        username: data['username'],
        password: data['password'],
        salt: data['salt'],
        avatar: data['avatar'],
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
        'username': username,
        'password': password,
        'salt': salt,
        'avatar': avatar,
        'created_at': createdAt == null ? null : createdAt.toIso8601String(),
        'updated_at': updatedAt == null ? null : updatedAt.toIso8601String()
      };

  static User parse(Map map) => new User.fromJson(map);
}

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
  _User user;

  @override
  DateTime createdAt;

  @override
  DateTime updatedAt;

  Message(
      {this.id,
      this.userId,
      this.text,
      this.user,
      this.createdAt,
      this.updatedAt});

  factory Message.fromJson(Map data) {
    return new Message(
        id: data['id'],
        userId: data['user_id'],
        text: data['text'],
        user: data['user'] == null
            ? null
            : (data['user'] is User
                ? data['user']
                : new User.fromJson(data['user'])),
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
        'user': user,
        'created_at': createdAt == null ? null : createdAt.toIso8601String(),
        'updated_at': updatedAt == null ? null : updatedAt.toIso8601String()
      };

  static Message parse(Map map) => new Message.fromJson(map);
}
