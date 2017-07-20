import 'dart:io';
import 'package:server/server.dart';
import 'package:angel_common/angel_common.dart';
import 'package:angel_test/angel_test.dart';
import 'package:test/test.dart';

main() async {
  Angel app;
  TestClient client;

  setUp(() async {
    app = await createServer();
    client = await connectTo(app);
  });

  tearDown(() async {
    await client.close();
    app = null;
  });

  test('index via REST', () async {
    var response = await client.get('/api/todos');
    expect(response, hasStatus(HttpStatus.OK));
  });

  test('Index todos', () async {
    var todos = await client.service('api/todos').index();
    print(todos);
  });
}