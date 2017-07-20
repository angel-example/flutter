library server.config.plugins;

import 'dart:async';
import 'package:angel_common/angel_common.dart';
import 'package:angel_seeder/angel_seeder.dart';

Future configureServer(Angel app) async {
  // Include any plugins you have made here.
  await app.configure(seedApp);
}

Future seedApp(Angel app) async {
  await app.configure(seedUsers);
}

Future seedUsers(Angel app) async {
  // Auto-generate users...
  app.justBeforeStart.add((app) async {
    await app.configure(seed(
        'api/users',
        new SeederConfiguration(count: 10, template: {
          'username': () => faker.internet.userName(),
          'password': () => faker.internet.password()
        })));
  });
}
