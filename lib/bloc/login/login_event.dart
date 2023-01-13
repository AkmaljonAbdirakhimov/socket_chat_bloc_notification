part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class TryToLoginEvent extends LoginEvent {
  final String userId;
  final String username;

  TryToLoginEvent({
    required this.userId,
    required this.username,
  });
}
