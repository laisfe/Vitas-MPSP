import 'package:chatbot/models/chat_message.dart';
import 'package:flutter/material.dart';

import 'package:bubble/bubble.dart';

class ChatMessageListItem extends StatelessWidget {
  final ChatMessage chatMessage;

  ChatMessageListItem({this.chatMessage});

  @override
  Widget build(BuildContext context) {
    return chatMessage.type == ChatMessageType.sent
        ? _showSentMessage()
        : _showReceivedMessage();
  }

  Widget _showSentMessage({EdgeInsets padding, TextAlign textAlign}) {
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(64.0, 0.0, 8.0, 0.0),
      trailing: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey[300],
            width: 2.0,
          ),
        ),
        child: CircleAvatar(
          radius: 24,
          backgroundColor: Colors.white,
          child: Text(
            "U",
            style: TextStyle(
              color: Color(0xffee2020),
              fontSize: 25.0,
            ),
          ),
        ),
      ),
      subtitle: Column(
        children: [
          Bubble(
            margin: BubbleEdges.only(top: 10),
            elevation: 1,
            alignment: Alignment.topRight,
            nip: BubbleNip.rightTop,
            color: Colors.red[100],
            child: Text(
              chatMessage.text,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showReceivedMessage() {
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(8.0, 0.0, 64.0, 0.0),
      leading: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey[300],
            width: 2.0,
          ),
        ),
        child: CircleAvatar(
          radius: 24,
          backgroundColor: Colors.white,
          child: Text(
            "V",
            style: TextStyle(
              color: Color(0xffee2020),
              fontSize: 25.0,
            ),
          ),
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          chatMessage.text == 'Escrevendo...'
              ? Text(chatMessage.text, textAlign: TextAlign.left)
              : Bubble(
                  margin: BubbleEdges.only(top: 10),
                  elevation: 1,
                  alignment: Alignment.topLeft,
                  nip: BubbleNip.leftTop,
                  child: Text(
                    chatMessage.text,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey[800],
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
