import 'package:angel_common/angel_common.dart';
import 'package:angel_framework/hooks.dart' as hooks;
import 'package:common/common.dart';

AngelConfigurer configureServer() {
  return (Angel app) async {
    app.use('/api/messages', new MapService());
    var service = app.service('api/messages') as HookedService;
    service.afterCreated.listen(hooks.transform(Message.parse));
    service.afterCreated.asStream().listen((e) {
      print('Created: ${e.result}');
    });
  };
}
