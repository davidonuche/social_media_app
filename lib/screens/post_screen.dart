import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/screens/create_post_screen.dart';
import 'package:social_media_app/screens/sign_in_screen.dart';
import 'package:social_media_app/widgets/post_item.dart';

import '../models/post_model.dart';
import 'chat_screen.dart';

class PostScreen extends StatefulWidget {
  static String routeName = "/post_screen";
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  Future<List<Post>>? post;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          actions: [
            // TODO:- Add post (pick image and go to create post screen)
            IconButton(
                onPressed: () async {
                  final ImagePicker imagePicker = ImagePicker();
                  final XFile? xFile = await imagePicker.pickImage(
                      source: ImageSource.gallery, imageQuality: 50);
                  if (xFile != null) {
                    Navigator.of(context).pushNamed(CreatePostScreen.routeName,
                        arguments: File(xFile.path));
                  }
                },
                icon: const Icon(
                  Icons.add,
                  size: 30,
                )),
            // TODO:- Navigate back to sign in screen.
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut().then(
                        (value) => Navigator.of(context)
                            .pushReplacementNamed(SignInScreen.routeName),
                      );
                },
                icon: const Icon(
                  Icons.logout,
                  size: 30,
                ))
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("posts").orderBy("timeStamp").snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError ||
                snapshot.connectionState == ConnectionState.none) {
              return Center(
                child: Text("Oops, something went wrong"),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final QueryDocumentSnapshot doc = snapshot.data!.docs[index];
               
                final Post post = Post.fromSnapshot(doc);
                return PostItem(post: post);
              },
            );
          },
        ));
  }
}
