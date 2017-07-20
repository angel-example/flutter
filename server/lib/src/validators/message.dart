library server.validtors.message;
import 'package:angel_validate/angel_validate.dart';

final Validator MESSAGE = new Validator({
  'name': [isString, isNotEmpty],
  'desc': [isString, isNotEmpty]
});

final Validator CREATE_MESSAGE = MESSAGE.extend({})
  ..requiredFields.addAll(['name', 'desc']);