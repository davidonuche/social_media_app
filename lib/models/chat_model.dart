import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String userID;
  final String username;
  final String message;
  final Timestamp timestamp;

  ChatModel({
    required this.userID,
    required this.username,
    required this.message,
    required this.timestamp,
  });
  ChatModel.fromSnapshot(QueryDocumentSnapshot doc)
      : userID = doc["userID"] as String,
        username = doc["userName"] as String,
        message = doc["message"] as String,
        timestamp = doc["timeStamp"] as Timestamp;
}
