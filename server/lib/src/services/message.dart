import 'package:angel_common/angel_common.dart';
import 'package:angel_framework/hooks.dart' as hooks;
import 'package:angel_relations/angel_relations.dart' as relations;
import 'package:angel_security/hooks.dart' as auth;
import 'package:angel_websocket/hooks.dart' as ws;

AngelConfigurer configureServer() {
  return (Angel app) async {
    app.use('/api/messages', new MapService());
    var service = app.service('api/messages') as HookedService;

    // Users should only be able to index the message collection,
    // read individual messages, and create new messages.
    //
    // Disable everything else (for clients);
    service.before([
      HookedServiceEvent.MODIFIED,
      HookedServiceEvent.UPDATED,
      HookedServiceEvent.REMOVED
    ], hooks.chainListeners([hooks.disable(), ws.doNotBroadcast()]));

    // Each message should have a `user_id` pointing to the user who sent it.
    //
    // Use this hook to automatically set a `user_id` on create events.
    // This hook also throws a 403 if the user is not logged in.
    service.beforeCreated
        .listen(auth.associateCurrentUser(ownerField: 'user_id'));

    // Use a simple belongsTo hook to populate a 'user' field.
    //
    // This assumes that each Message has a `user_id`. It then
    // searches the `api/users` services for a user with a matching ID.
    //
    // If it finds a user, it sets `user` to the user it finds. The hook
    // is intelligent enough to set this `user` field on both Maps and Dart
    // objects without hassle.
    service.afterAll(
        relations.belongsTo('api/users', as: 'user', localKey: 'user_id'));
  };
}
