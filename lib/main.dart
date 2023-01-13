import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_chat/bloc/login/login_bloc.dart';
import 'package:socket_chat/screens/chat_screen.dart';
import 'package:socket_chat/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (ctx) => LoginBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocBuilder<LoginBloc, LoginState>(
          builder: (c, state) {
            if (state is LoginSuccess) {
              return ChatScreen(
                userId: state.userId,
                username: state.username,
              );
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
