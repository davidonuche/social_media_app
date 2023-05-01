import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget { 
  static String routeName = "/sign_up_screen";
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String _email = "";
  String _username = "";
  String _password = "";
  late final FocusNode _usernameFocusNode;
  late final FocusNode _passwordFocusNode;
  final _formKey = GlobalKey<FormState>();
  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    // TODO:- Sign Up with email and password.
    // TODO:- Send email to verify.
  }

  @override
  void initState() {
    _usernameFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            physics: ClampingScrollPhysics(),
            padding: EdgeInsets.all(15),
            children: [
              // TODO:- Email
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                onSaved: (value) {
                  _email = value!.trim();
                },
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_usernameFocusNode),
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    labelText: "Enter Email"),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "Please Provide Email...";
                  }
                  if (value!.length < 4) {
                    return "Please provide longer email...";
                  }
                  return null;
                },
              ),
              // TODO:- User name
              TextFormField(
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
                focusNode: _usernameFocusNode,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_passwordFocusNode),
                onSaved: (value) {
                  _username = value!.trim();
                },
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    labelText: "Enter User Name"),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "Please Provide UserName...";
                  }
                  if (value!.length < 4) {
                    return "Please provide longer UserName...";
                  }
                  return null;
                },
              ),
              // TODO:- Password
              TextFormField(
                focusNode: _passwordFocusNode,
                textInputAction: TextInputAction.done,
                obscureText: true,
                onFieldSubmitted: (_) => _submit(),
                onSaved: (value) {
                  _password = value!.trim();
                },
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    labelText: "Enter Password"),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "Please Provide Password...";
                  }
                  if (value!.length < 4) {
                    return "Please provide longer Password...";
                  }
                  return null;
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    // TODO:- Sign Up.
                  },
                  child: Text("Sign Up")),
              TextButton(
                  onPressed: () {
                    // TODO:- Go to sign in screen.
                  },
                  child: Text("Sign In Instead")),
            ],
          ),
        ),
      ),
    );
  }
}
