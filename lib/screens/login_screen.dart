import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_chat/bloc/login/login_bloc.dart';
import 'package:socket_chat/screens/chat_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  String _username = '';
  final String _userId = UniqueKey().toString();

  void _startChat() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      BlocProvider.of<LoginBloc>(context).add(TryToLoginEvent(
        userId: _userId,
        username: _username,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (ctx, state) {
        if (state is LoginError) {
          showDialog(
            context: ctx,
            builder: (c) {
              return AlertDialog(
                title: const Text('Xatolik!'),
                content: Text(state.message),
                actions: [
                  TextButton(
                    onPressed: () {
                      _usernameController.text = '';
                      Navigator.of(c).pop();
                    },
                    child: const Text('Okay'),
                  ),
                ],
              );
            },
          );
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Ismingizni kiriting',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Iltimos, ismingizni kiriting!';
                    }

                    return null;
                  },
                  onSaved: (value) {
                    _username = value!;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    if (state is UserLogging) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ElevatedButton(
                      onPressed: _startChat,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                      ),
                      child: const Text('CHATNI BOSHLASH'),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
