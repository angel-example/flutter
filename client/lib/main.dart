import 'dart:async';
import 'package:angel_client/flutter.dart';
import 'package:angel_websocket/flutter.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(new ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(primarySwatch: Colors.teal),
      home: new ChatHome(),
    );
  }
}

class ChatHome extends StatefulWidget {
  @override
  State createState() => new _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
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
        body: new ChatLogin((AngelAuthResult auth) {
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

    if (connecting)
      body = new Text('Connecting to server...');
    else if (error)
      body = new Text('An error occurred while connecting to the server.');
    else {
      body = new ChatMessageList(service, messages, user);
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Chat (${messages.length} messages)'),
      ),
      body: body,
    );
  }
}

class ChatMessageList extends StatelessWidget {
  final Service service;
  final List<Message> messages;
  final User user;

  ChatMessageList(this.service, this.messages, this.user);

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Flexible(
          child: new ListView.builder(
              itemCount: messages.length,
              itemBuilder: (_, int i) {
                return new ListTile(
                  title: new Text(messages[i].text),
                );
              }),
        ),
        new Divider(height: 1.0),
        new Container(
          decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          child: new Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: new TextField(
              decoration: new InputDecoration(labelText: 'Send a message...'),
              onSubmitted: (String msg) {
                service.create({'text': msg, 'user_id': user.id});
              },
            ),
          ),
        )
      ],
    );
  }
}

class ChatLogin extends StatefulWidget {
  final SetAuth setAuth;

  ChatLogin(this.setAuth);

  @override
  State createState() => new _ChatLoginState(setAuth);
}

typedef void SetAuth(AngelAuthResult auth);

class _ChatLoginState extends State<ChatLogin> {
  Angel restApp = new Rest('http://10.134.80.167:3000');
  final SetAuth setAuth;
  String username, password;
  bool sending = false;

  _ChatLoginState(this.setAuth);

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(16.0),
      child: new Form(
        child: new Column(
          children: <Widget>[
            new TextField(
              decoration: new InputDecoration(labelText: 'Username'),
              onChanged: (String str) => setState(() => username = str),
            ),
            new TextField(
              decoration: new InputDecoration(labelText: 'Password'),
              onChanged: (String str) => setState(() => password = str),
            ),
            sending
                ? new CircularProgressIndicator()
                : new RaisedButton(
                    onPressed: () {
                      setState(() => sending = true);
                      restApp.authenticate(type: 'local', credentials: {
                        'username': username,
                        'password': password
                      }).then((auth) {
                        setAuth(auth);
                      }).catchError((e) {
                        showDialog(
                            context: context,
                            child: new SimpleDialog(
                              title: new Text('Login Error: $e'),
                            ));
                      }).whenComplete(() {
                        setState(() => sending = false);
                      });
                    },
                    color: Theme.of(context).primaryColor,
                    highlightColor: Theme.of(context).highlightColor,
                    child: new Text(
                      'SUBMIT',
                      style: new TextStyle(color: Colors.white),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
