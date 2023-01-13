import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:socket_chat/helpers/custom_notification.dart';
import 'package:socket_chat/helpers/socket_stream.dart';
import 'package:socket_chat/widgets/message.dart' as widgetBox;
import 'package:socket_io_client/socket_io_client.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    

class ChatScreen extends StatefulWidget {
  final String username;
  final String userId;
  const ChatScreen({
    required this.userId,
    required this.username,
    super.key,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final socketStream = SocketStream();
  final _messageController = TextEditingController();
  late Socket socket;
  final List<Map<String, dynamic>> _messages = [];
  bool _isAppinBackground = false;

  

  @override
  void initState() {
    super.initState();
    _connectSocket();
    WidgetsBinding.instance.addObserver(this);

    CustomNotification.init(flutterLocalNotificationsPlugin);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _isAppinBackground = state == AppLifecycleState.paused;
  }

  void _connectSocket() {
    socket = io(
      Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://localhost:3000',
      OptionBuilder().setTransports(['websocket']).build(),
    );

    socket.onConnect((_) {
      print('Socket Client ishga tushdi.');
    });

    // backend tomonidan ishlagandi
    socket.on('xabarKeldi', (xabar) {
      _messages.add(xabar);
      socketStream.addResponse(_messages);
      if (widget.userId != xabar['userId'] && _isAppinBackground) {
        CustomNotification.show(
          title: 'Yangi Xabar!',
          body: xabar['message'],
          flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
        );
      }
    });

    socket.onDisconnect((_) => print('Socket client tuxtatildi'));
  }

  void _sendMessage() {
    if (_messageController.text != '') {
      socket.emit('xabarYuborish', {
        'message': _messageController.text.trim(),
        'username': widget.username,
        'userId': widget.userId,
      });
      _messageController.clear();
    }
  }

  @override
  void dispose() {
    socket.close();
    socket.dispose();
    socketStream.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Socket Chat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: socketStream.getResponse,
                builder: (streamCtx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    return ListView.builder(
                      itemCount: _messages.length,
                      itemBuilder: (ctx, i) {
                        return widgetBox.Message(
                          username: _messages[i]['username'],
                          isMe: widget.userId == _messages[i]['userId'],
                          message: _messages[i]['message'],
                        );
                      },
                    );
                  }
                  return const Center(
                    child: Text('Xabar yozishni boshlang!'),
                  );
                },
              ),
            ),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: 'Xabar yozing...',
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                suffixIcon: IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
