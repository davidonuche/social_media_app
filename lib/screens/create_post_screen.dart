import 'dart:io';

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
  _submit(File image) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    // TODO: Write Image and Description to Database
    // Pop the screen
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final File image = ModalRoute.of(context)!.settings.arguments as File;
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: ListView(
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
              autocorrect: false,
              textCapitalization: TextCapitalization.none,
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black))),
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(image),
            ),
          ],
        ),
      ),
    );
  }
}
