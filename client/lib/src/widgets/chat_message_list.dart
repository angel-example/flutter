import 'package:angel_client/angel_client.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';

/// Simply renders a list of chat messages.
class ChatMessageList extends StatelessWidget {
  /// An [Angel] client pointing toward an HTTP server.
  ///
  /// We need it for its [basePath] property.
  final Angel restApp;

  /// A client-side [Service], which mirrors the server-side implementation.
  ///
  /// We use this to create messages on the server, in this case via WebSocket.
  final Service service;
  final List<Message> messages;
  final User user;

  ChatMessageList(this.restApp, this.service, this.messages, this.user);

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Flexible(
          child: messages.isEmpty
              ? new Text('Nobody has said anything yet... Break the silence!')
              : new ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (_, int i) {
                    return new ListTile(
                      // Resolve the path of an image on the server, using the `basePath`
                      // of our `restApp`.
                      leading: new Image.network(
                          '${restApp.basePath}/images/${messages[i].user.avatar}'),
                      title: new Text(
                        messages[i].user.username,
                        style: new TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: new Text(messages[i].text),
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
                if (msg.isNotEmpty) {
                  // When the user wants to send a message, all
                  // we need to do is send an action through our
                  // WebSocket.
                  //
                  // `package:angel_websocket` provides a clean API
                  // that accomplishes this while also implementing the
                  // `package:angel_client` API.
                  //
                  // This resembles the server-side, and makes developing full-stack
                  // with Angel make a little bit more sense.
                  //
                  // We don't need to call any fancy state-setting functions, because
                  // our chat app is already listening to our WebSocket to modify its state
                  // when new messages come in.
                  service.create({'text': msg});
                }
              },
            ),
          ),
        )
      ],
    );
  }
}
