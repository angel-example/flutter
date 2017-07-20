import 'package:angel_client/flutter.dart';
import 'package:flutter/material.dart';

/// A callback that handles the result of successful authentication against a server.
typedef void HandleAuth(AngelAuthResult auth);

/// Renders a log-in screen that POSTs to /auth/lccal on our server.
class ChatLogin extends StatefulWidget {
  /// An [Angel] client that interacts with the server over plain HTTP.
  ///
  /// We need this to POST to /auth/local and receive a JWT.
  ///
  /// Once we receive the JWT, we can use it to authenticate our WebSocket.
  final Angel restApp;

  /// Invoke this with the [AngelAuthResult] that contains an authenticated user, and a JWT.
  final HandleAuth handleAuth;

  ChatLogin(this.restApp, this.handleAuth);

  @override
  State createState() => new _ChatLoginState(restApp, handleAuth);
}

class _ChatLoginState extends State<ChatLogin> {
  final Angel restApp;
  final HandleAuth handleAuth;
  String username, password;
  bool sending = false;

  _ChatLoginState(this.restApp, this.handleAuth);

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

                      // The `authenticate` method will not only POST to /auth/<type>,
                      // but also parse the server's response.
                      //
                      // Naturally, this API expects that your server is using
                      // `package:angel_auth`, which issues signed JWT's.
                      //
                      // For more documentation:
                      // * https://github.com/angel-dart/auth
                      // * https://github.com/angel-dart/client
                      // * https://jwt.io
                      restApp.authenticate(type: 'local', credentials: {
                        'username': username,
                        'password': password
                      }).then((auth) {
                        // Alert the parent widget that we've logged in!
                        handleAuth(auth);
                      }).catchError((e) {
                        // If we fail to log-in, tell the user that something went wrong.
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
