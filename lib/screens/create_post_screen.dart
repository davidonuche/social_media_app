import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:flutter/material.dart';

class CreatePostScreen extends StatefulWidget {
  static String routeName = "/create_post_screen";
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  String _description = "";
  Future<void> _submit(File image) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    // write image to storage
    storage.FirebaseStorage firebaseStorage = storage.FirebaseStorage.instance;
    late String imageUrl;
    await firebaseStorage
        .ref("image/${UniqueKey()}.png")
        .putFile(image)
        .then((taskSnapshot) async {
      imageUrl = await taskSnapshot.ref.getDownloadURL();
    });

    //  Add to cloud firestore
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("post");
    collectionReference.add({
      "userId": FirebaseAuth.instance.currentUser!.uid,
      "description": _description,
      "timeStamp": Timestamp.now(),
      "userName": FirebaseAuth.instance.currentUser!.displayName,
      "imageUrl": imageUrl,
    }).then((docReference) => docReference.update({"postID" : docReference.id}));
    // Pop the screen
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final File image = ModalRoute.of(context)!.settings.arguments as File;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(18),
          children: [
            Image.file(image, fit: BoxFit.cover),
            // Decription Text Field
            TextFormField(
              onSaved: (value) {
                _description = value!;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please provide description";
                }
                return null;
              },
              textCapitalization: TextCapitalization.none,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              autocorrect: false,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(image),
            ),
          ],
        ),
      ),
    );
  }
}
