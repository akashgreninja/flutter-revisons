import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_for_vs/constants/routes.dart';
import 'dart:developer' as devtools show log;
import '../firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
      appBar: AppBar(title: Text("Register page")),
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
                      .createUserWithEmailAndPassword(
                          email: email, password: password);
                  // ignore: avoid_print
                  devtools.log(creds.toString());
                } on FirebaseAuthException catch (e) {
                  if (e.code == "email-already-in-use") {
                    devtools.log("already in use");
                  } else if (e.code == " weak-password") {
                    devtools.log("password weak");
                  } else if (e.code == "invalid-email") {
                    devtools.log("invalid-email");
                  }
                }
              },
              child: const Text("yeetus"),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute, (Route<dynamic> route) => false);
                },
                child: Text("Already Registered? Log in"))
          ],
        ),
      ),
    );
  }
}
