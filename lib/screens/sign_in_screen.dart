import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  static String routeName = "/sign_in_screen";
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String _email = "";
  String _password = "";
  late final FocusNode _passwordFocusNode;
  final _formKey = GlobalKey<FormState>();
  void submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    // TODO:- Authenticate with email and password.
    // TODO:- if verified go to post screen.
    // TODO:- add email verification.
  }

  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
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
            // Email
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.none,
              autocorrect: false,
              textInputAction: TextInputAction.next,
              onSaved: (value) {
                _email = value!.trim();
              },
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_passwordFocusNode),
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
            //Password
            TextFormField(
              focusNode: _passwordFocusNode,
              obscureText: true,
              textInputAction: TextInputAction.done,
              onSaved: (value) {
                _password = value!.trim();
              },
              onFieldSubmitted: (value) {
                // TODO:- Submit Form
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
                if (value!.length < 5) {
                  return "Please provide longer password...";
                }
                return null;
              },
            ),
            ElevatedButton(
                onPressed: () {
                  // TODO:- Submit form and authenticate with email and password.
                },
                child: Text("Log In")),
            TextButton(
                onPressed: () {
                  // TODO:- Go to sign up screen.
                },
                child: Text("Sign Up Instead")),
          ],
        ),
      )),
    );
  }
}
