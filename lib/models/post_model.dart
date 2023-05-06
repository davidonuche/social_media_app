import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String userId;
  final String userName;
  final Timestamp timestamp;
  final String imageUrl;
  final String description;
  Post({
    required this.userId,
    required this.userName,
    required this.timestamp,
    required this.imageUrl,
    required this.description,
  });
}
