library common.models.user;
import 'package:angel_framework/common.dart';
import 'package:angel_serialize/angel_serialize.dart';
part 'user.g.dart';

@serializable
class _User extends Model {
  String username, password, salt;
}
