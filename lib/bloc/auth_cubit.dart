import 'package:bloc/bloc.dart';
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
      UserCredential usercredential =
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
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      userCredential.user!.updateDisplayName(username);
      //TODO:- Write our user to cloud firestore.
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
