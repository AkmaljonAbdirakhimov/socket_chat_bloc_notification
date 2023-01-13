part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class UserLogging extends LoginState {}

class LoginSuccess extends LoginState {
  final String userId;
  final String username;

  LoginSuccess({
    required this.userId,
    required this.username,
  });
}

class LoginError extends LoginState {
  final String message;

  LoginError(this.message);
}
