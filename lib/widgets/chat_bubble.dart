import 'package:flutter/material.dart';
import 'package:social_media_app/models/chat_model.dart';

class ChatBubble extends StatelessWidget {
  final ChatModel chatModel;
  final String currentUserID;
  const ChatBubble({required this.currentUserID, required this.chatModel, super.key});
  

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: chatModel.userID == currentUserID ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
          bottomLeft: chatModel.userID == currentUserID
              ? Radius.circular(15)
              : Radius.zero,
          bottomRight: chatModel.userID == currentUserID
              ? Radius.zero
              : Radius.circular(15),
        ),
      ),
      child: Column(
        crossAxisAlignment: chatModel.userID == currentUserID
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text("By${chatModel.username}",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 5,
          ),
          Text(
            chatModel.message,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
