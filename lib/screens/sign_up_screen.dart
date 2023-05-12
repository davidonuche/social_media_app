import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/screens/post_screen.dart';
import 'package:social_media_app/screens/sign_in_screen.dart';

import '../bloc/auth_cubit.dart';

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
    context.read<AuthCubit>().signUpWithEmail(
          email: _email,
          password: _password,
          username: _username,
        );
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
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (prevState, currentState) async {
              if (currentState is AuthSignedUp) {
                 //Navigator.of(context).pushReplacementNamed(PostScreen.routeName);
              }
              if (currentState is AuthError) {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Theme.of(context).errorColor,
                    content: Text(
                      currentState.message,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onError),
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
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
                      if (value == null || value.isEmpty) {
                        return "Please Provide Email...";
                      }
                      if (value.length < 4) {
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
                      if (value == null || value.isEmpty) {
                        return "Please Provide UserName...";
                      }
                      if (value.length < 4) {
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
                      if (value == null || value.isEmpty) {
                        return "Please Provide Password...";
                      }
                      if (value.length < 4) {
                        return "Please provide longer Password...";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8,),
                  ElevatedButton(
                      onPressed: () {
                        _submit();
                      },
                      child: Text("Sign Up")),
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(SignInScreen.routeName),
                    child: Text("Sign In Instead"),
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
