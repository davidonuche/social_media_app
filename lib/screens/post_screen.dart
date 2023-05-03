import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  static String routeName = "/post_screen";
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          // TODO:- Add post (pick image and go to create post screen)
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.add,
                size: 30,
              )),
          // TODO:- Navigate back to sign in screen.
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.logout,
                size: 30,
              ))
        ],
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container();
        },
      ),
    );
  }
}
