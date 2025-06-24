import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:masaar/widgets/custom%20widgets/custom_app_bar.dart';

class MyChat extends StatefulWidget {
  const MyChat({super.key, required this.driverName});
  final String driverName;

  @override
  MyChatState createState() => MyChatState();
}

class MyChatState extends State<MyChat> {
  final _chatController = InMemoryChatController();

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    final chatTheme =
        brightness == Brightness.dark ? ChatTheme.dark() : ChatTheme.light();
    return Scaffold(
      appBar: CustomAppBar(driverName: widget.driverName),
      body: Chat(
        chatController: _chatController,
        currentUserId: 'user1',
        onMessageSend: (text) {
          _chatController.insertMessage(
            TextMessage(
              // Better to use UUID or similar for the ID - IDs must be unique.
              id: '${Random().nextInt(1000) + 1}',
              authorId: 'user1',
              createdAt: DateTime.now().toUtc(),
              text: text,
            ),
          );
        },
        resolveUser: (UserID id) async {
          return User(id: id, name: 'John');
        },
        theme: chatTheme.copyWith(
          colors: chatTheme.colors.copyWith(
            primary: Color(0xFF6A42C2), // Changes primary for the active theme
          ),
        ),
      ),
    );
  }
}
