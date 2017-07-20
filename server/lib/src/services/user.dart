import 'dart:math' as math;
import 'package:angel_common/angel_common.dart';
import 'package:angel_framework/hooks.dart' as hooks;
import 'package:angel_websocket/hooks.dart' as ws;
import 'package:crypto/crypto.dart' show sha256;
import 'package:random_string/random_string.dart' as rs;
// import '../validators/user.dart';

const List<String> avatars = const [
  'dart.png',
  'favicon.png',
  'flutter.jpg',
  'google.png'
];

/// Sets up a service mounted at `api/users`.
///
/// In the real world, you will want to hook this up to a database.
/// However, for the sake of the boilerplate, an in-memory service is used,
/// so that users are not tied into using just one database. :)
configureServer() {
  return (Angel app) async {
    // Store data in-memory.
    app.use('/api/users', new MapService());

    // Configure hooks for the user service.
    // Hooks can be used to add additional functionality, or change the behavior
    // of services, and run on any service, regardless of which database you are using.
    //
    // If you have not already, *definitely* read the service hook documentation:
    // https://github.com/angel-dart/angel/wiki/Hooks

    var service = app.service('api/users') as HookedService;

    // Clients can't create, modify, update, or remove users.
    //
    // Refrain from broadcasting these events via WebSockets.
    service.before([
      HookedServiceEvent.CREATED,
      HookedServiceEvent.MODIFIED,
      HookedServiceEvent.UPDATED,
      HookedServiceEvent.REMOVED
    ], hooks.chainListeners([hooks.disable(), ws.doNotBroadcast()]));

    // Hash user passwords.
    service.beforeCreated.listen((e) {
      var salt = rs.randomAlphaNumeric(12);
      e.data
        ..['password'] = hashPassword(e.data['password'], salt, app.jwt_secret)
        ..['salt'] = salt;
    });

    // Choose a random avatar when a new user is created.
    var rnd = new math.Random();

    service.beforeCreated.listen((HookedServiceEvent e) {
      var avatar = avatars[rnd.nextInt(avatars.length)];
      e.data['avatar'] = avatar;
    });

    // Remove sensitive data from serialized JSON.
    service.afterAll(hooks.remove(['password', 'salt']));
  };
}

/// SHA-256 hash any string, particularly a password.
String hashPassword(String password, String salt, String pepper) =>
    sha256.convert(('$salt:$password:$pepper').codeUnits).toString();
