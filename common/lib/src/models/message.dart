library common.models.message;
import 'package:angel_framework/common.dart';
import 'package:angel_serialize/angel_serialize.dart';
part 'message.g.dart';

@serializable
class _Message extends Model {
  String userId, text;
}