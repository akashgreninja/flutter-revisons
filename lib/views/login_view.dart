import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:flutter_test_for_vs/constants/routes.dart';
import 'package:flutter_test_for_vs/services/auth/auth_service.dart';
import 'package:flutter_test_for_vs/services/auth/authexceptions.dart';

import '../utilities/errorcode.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login view")),
      body: Center(
        child: Column(
          children: [
            TextField(
              enableSuggestions: true,
              autocorrect: true,
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'Enter your email'),
            ),
            TextField(
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              controller: _password,
              decoration: const InputDecoration(hintText: 'Enter your pass'),
            ),
            TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;

                try {
                  await AuthService.firebase()
                      .logIn(email: email, password: password);
                  // ignore: avoid_print
                  // devtools.log(creds.toString());
                  final user = AuthService.firebase().currentUser;
                  if (user?.isEmailVerified ?? false) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        notes, (Route<dynamic> route) => false);
                  } else {
                    Navigator.of(context).pushNamed(VerifyEmailRoute);
                  }
                } on UserNotFoundAuthException {
                  await showErrorDialog(
                    context,
                    'user not found',
                  );
                } on WeakPasswordAuthException {
                  await showErrorDialog(
                    context,
                    'password not correct',
                  );
                } on GerericAuthException {
                  await showErrorDialog(context, 'Auth error');
                }
              },
              child: const Text("yeetus"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/register/', (Route<dynamic> route) => false);
              },
              child: Text("Not Registered? Register Here"),
            )
          ],
        ),
      ),
    );
  }
}
