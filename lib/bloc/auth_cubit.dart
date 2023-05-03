import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    // ...logic
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // if success emit AuthSignedIn()
      emit(AuthSignedIn());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(AuthError('User not found. '));
      } else if (e.code == 'wrong-password') {
        emit(AuthError('Wrong password.'));
      }
    }
  }

  Future<void> signUpWithEmail({
    required String email,
    required String username,
    required String password,
  }) async {
    emit(AuthLoading());
    // ...logic
    try {
      // 1. create user
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // 2. update user profile
      userCredential.user!.updateDisplayName(username);
      // 3. Write user to users collection
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({
        "email": email,
        "username": username,
      });
      await userCredential.user!.sendEmailVerification();
      // if success emit AuthSignedUp()
      emit(AuthSignedUp());

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(AuthError("The password provided is too weak."));
      } else if (e.code == 'email-already-in-use') {
        emit(AuthError("The email is already in use."));
      }
    } catch (e) {
      emit(AuthError("An error has occured..."));
    }
  }
}
