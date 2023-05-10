import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String userId;
  final String userName;
  final Timestamp timestamp;
  final String imageUrl;
  final String description;
  final String postID;
  Post({
    required this.userId,
    required this.userName,
    required this.timestamp,
    required this.imageUrl,
    required this.description,
    required this.postID,
  });
  Post.fromSnapshot(QueryDocumentSnapshot doc)
      : userId = doc["userId"] as String,
        userName = doc["userName"] as String,
        timestamp = doc["timeStamp"] as Timestamp,
        imageUrl = doc["imageUrl"] as String,
        description = doc["description"] as String,
        postID = doc["postID"] as String;
}
