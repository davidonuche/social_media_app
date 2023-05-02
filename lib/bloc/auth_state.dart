part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {
  AuthInitial();
}

class AuthLoading extends AuthState {
  AuthLoading();
}

class AuthSignedUp extends AuthState {
  AuthSignedUp();
}

class AuthSignedIn extends AuthState {
  AuthSignedIn();
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
    @override
  List<Object> get props => [message];
}