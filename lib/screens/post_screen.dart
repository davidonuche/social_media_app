import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/screens/create_post_screen.dart';
import 'package:social_media_app/screens/sign_in_screen.dart';

import '../models/post_model.dart';

class PostScreen extends StatefulWidget {
  static String routeName = "/post_screen";
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  Future<List<Post>>? post;
  @override
  void initState() {
    post = FirebaseFirestore.instance
        .collection("post")
        .get()
        .then((QuerySnapshot querySnapshot) {
      List<Post> post = [];
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        post.add(
          Post(
            userName: doc["userName"] as String,
            timestamp: doc["timeStamp"] as Timestamp,
            description: doc["description"] as String,
            imageUrl: doc["imageUrl"] as String,
            userId: doc["userId"] as String,
          ),
        );
        return post;
      }
      querySnapshot.docs.forEach((element) {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: FutureBuilder(
        future: post,
        builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(child: Text("No connection"));
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.done:
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final Post post = snapshot.data![index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Image.network(post.imageUrl),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          post.userName,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          post.description,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
