import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:social_media_app/bloc/auth_cubit.dart';
import 'package:social_media_app/screens/chat_screen.dart';
import 'package:social_media_app/screens/create_post_screen.dart';
import 'package:social_media_app/screens/post_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/sign_up_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://0cd34220a0654f9e98ab760f88c7ea11@o4505173272559616.ingest.sentry.io/4505173310177280';
    },
    // Init your App.
    appRunner: () => runApp(MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

// Checks authState
  Widget _buildHomeScreen() {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.emailVerified) {
              return PostScreen();
            }
            return SignInScreen();
          } else {
            return SignInScreen();
          }
        });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => AuthCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: _buildHomeScreen(),
        routes: {
          SignUpScreen.routeName: (context) => SignUpScreen(),
          SignInScreen.routeName: (context) => SignInScreen(),
          PostScreen.routeName: (context) => PostScreen(),
          CreatePostScreen.routeName: (context) => CreatePostScreen(),
          ChatScreen.routeName: (context) => ChatScreen(),
        },
      ),
    );
  }
}
