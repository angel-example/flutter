library common.models;
import 'package:angel_framework/common.dart';
import 'package:angel_serialize/angel_serialize.dart';
part 'models.g.dart';

@serializable
class _User extends Model {
  String username, password, salt, avatar;
}

@serializable
class _Message extends Model {
  String userId, text;
  _User user;
}