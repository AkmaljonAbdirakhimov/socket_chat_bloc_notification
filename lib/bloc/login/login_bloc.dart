import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<TryToLoginEvent>(tryToLogin);
  }

  tryToLogin(TryToLoginEvent event, Emitter<LoginState> emit) async {
    emit(UserLogging());
    await Future.delayed(const Duration(seconds: 5));
    try {
      // save user data
      // ...
      emit(LoginSuccess(
        userId: event.userId,
        username: event.username,
      ));
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }
}
