library server.cluster;

import 'dart:async';
import 'common.dart';
import 'dart:isolate';

main(args, SendPort sendPort) async {
  runZoned(startServer(args, sendPort: sendPort), onError: onError);
}
