import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/models/chat_model.dart';

class ChatScreen extends StatefulWidget {
  static String routeName = "/chat_screen";
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String _message = "";
  final String currentUserID = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    final String postID = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("post")
              .doc(postID)
              .collection("chat")
              .orderBy(
                "timeStamp",
              )
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError ||
                snapshot.connectionState == ConnectionState.none) {
              return Center(
                child: Text("Error"),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final QueryDocumentSnapshot doc =
                              snapshot.data!.docs[index];
                          final ChatModel chatModel =
                              ChatModel.fromSnapshot(doc);

                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: chatModel.userID == currentUserID
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: chatModel.userID == currentUserID
                                        ? Colors.blue
                                        : Colors.grey,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                      bottomLeft:
                                          chatModel.userID == currentUserID
                                              ? Radius.circular(15)
                                              : Radius.zero,
                                      bottomRight:
                                          chatModel.userID == currentUserID
                                              ? Radius.zero
                                              : Radius.circular(15),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        chatModel.userID == currentUserID
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start,
                                    children: [
                                      Text("By${chatModel.username}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        chatModel.message,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ));
                        }),
                  ),
                  SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter Message"),
                            onChanged: (value) {
                              _message = value.trim();
                            },
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              if (_message.isNotEmpty) {
                                FirebaseFirestore.instance
                                    .collection("post")
                                    .doc(postID)
                                    .collection("chat")
                                    .add({
                                  "userID":
                                      FirebaseAuth.instance.currentUser!.uid,
                                  "userName": FirebaseAuth
                                      .instance.currentUser!.displayName,
                                  "message": _message,
                                  "timeStamp": Timestamp.now(),
                                });
                                setState(() {
                                  _message = "";
                                });
                              }
                            },
                            icon: Icon(Icons.arrow_forward_ios))
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
