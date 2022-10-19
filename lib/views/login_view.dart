import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import '../firebase_options.dart';
import 'package:flutter_test_for_vs/constants/routes.dart';

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
                  final creds = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: email, password: password);
                  // ignore: avoid_print
                  devtools.log(creds.toString());
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      notes, (Route<dynamic> route) => false);
                } on FirebaseAuthException catch (e) {
                  // devtools.log("oopsie");
                  // devtools.log(e.code);
                  // devtools.log(e.runtimeType)
                  if (e.code == " user-not-found") {
                    devtools.log("user does not exist");
                  } else if (e.code == 'wrong-password') {
                    devtools.log("wrong password ");
                    devtools.log(e.code);
                  }
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
