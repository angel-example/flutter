library server.validtors.todo;
import 'package:angel_validate/angel_validate.dart';

final Validator TODO = new Validator({
  'name': [isString, isNotEmpty],
  'desc': [isString, isNotEmpty]
});

final Validator CREATE_TODO = TODO.extend({})
  ..requiredFields.addAll(['name', 'desc']);