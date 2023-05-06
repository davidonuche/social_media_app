import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/bloc/auth_cubit.dart';
import 'package:social_media_app/screens/create_post_screen.dart';
import 'package:social_media_app/screens/post_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/sign_up_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => AuthCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.dark(),
        home: SignInScreen(),
        routes: {
          SignUpScreen.routeName:(context) => SignUpScreen(),
          SignInScreen.routeName:(context) => SignInScreen(),
          PostScreen.routeName:(context) => PostScreen(),
          CreatePostScreen.routeName:(context) => CreatePostScreen(),
        },
      ),
    );
  }
}

