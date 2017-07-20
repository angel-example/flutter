import 'dart:async';
import 'package:angel_client/flutter.dart';
import 'package:angel_websocket/flutter.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'chat_login.dart';
import 'chat_message_list.dart';

class ChatHome extends StatefulWidget {
  @override
  State createState() => new _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  final Angel restApp = new Rest('http://10.134.80.167:3000');
  String token;
  User user;
  WebSockets wsApp;
  Service service;
  bool connecting = true, error = false;
  List<Message> messages = [];

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text('Log In'),
        ),
        body: new ChatLogin(restApp, (AngelAuthResult auth) {
          setState(() {
            user = User.parse(auth.data);
            token = auth.token;
            wsApp = new WebSockets('ws://10.134.80.167:3000/ws');
          });

          wsApp
              .connect()
              .then((_) {
            var c = new Completer();
            StreamSubscription onAuth, onError;

            onAuth = wsApp.onAuthenticated.listen((_) {
              service = wsApp.service('api/messages');

              service
                ..onIndexed.listen((WebSocketEvent e) {
                  setState(() {
                    messages
                      ..clear()
                      ..addAll(e.data.map(Message.parse));
                  });
                })
                ..onCreated.listen((WebSocketEvent e) {
                  setState(() {
                    messages.add(Message.parse(e.data));
                  });
                });

              service.index();
              onAuth.cancel();
              c.complete();
            });

            onError = wsApp.onError.listen((e) {
              onError.cancel();
              c.completeError(e);
            });

            wsApp.authenticateViaJwt(auth.token);
            return c.future;
          })
              .timeout(new Duration(minutes: 1))
              .catchError((e) {
            showDialog(
                context: context,
                child: new SimpleDialog(
                  title: new Text('Couldn\'t connect to chat server.'),
                )).then((_) {
              setState(() => error = true);
            });
          })
              .whenComplete(() {
            setState(() => connecting = false);
          });
        }),
      );
    }

    Widget body;

    // Render different content depending on the state of the application.
    if (connecting)
      body = new Text('Connecting to server...');
    else if (error)
      body = new Text('An error occurred while connecting to the server.');
    else {
      body = new ChatMessageList(restApp, service, messages, user);
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Chat (${messages.length} messages)'),
      ),
      body: body,
    );
  }
}