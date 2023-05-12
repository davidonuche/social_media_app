import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/bloc/auth_cubit.dart';
import 'package:social_media_app/screens/sign_up_screen.dart';

import 'post_screen.dart';

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
  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    context.read<AuthCubit>().signInWithEmail(
          email: _email,
          password: _password,
        );
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
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (prevState, currState) {
              if (currState is AuthError) {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Theme.of(context).errorColor,
                    content: Text(
                      currState.message,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onError),
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
              if (currState is AuthSignedIn) {
                // Navigator.of(context)
                    // .pushReplacementNamed(PostScreen.routeName);
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
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
                      if (value == null || value.isEmpty) {
                        return "Please Provide Email...";
                      }
                      if (value.length < 4) {
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
                    onFieldSubmitted: (value) => _submit(),
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        labelText: "Enter Password"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Provide Password...";
                      }
                      if (value.length < 5) {
                        return "Please provide longer password...";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                      onPressed: () => _submit(), child: Text("Log In")),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(SignUpScreen.routeName);
                    },
                    child: Text("Sign Up Instead"),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
