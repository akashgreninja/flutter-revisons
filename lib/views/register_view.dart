import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_for_vs/constants/routes.dart';
import 'package:flutter_test_for_vs/views/VerifyEmailView.dart';
import 'dart:developer' as devtools show log;
import '../firebase_options.dart';
import '../utilities/errorcode.dart';

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
                  // devtools.log(creds.toString());
                  final user = FirebaseAuth.instance.currentUser;
                  await user?.sendEmailVerification();
                  Navigator.of(context).pushNamed(VerifyEmailRoute);
                } on FirebaseAuthException catch (e) {
                  if (e.code == "email-already-in-use") {
                    await showErrorDialog(
                      context,
                      'email already in use',
                    );
                  } else if (e.code == " weak-password") {
                    await showErrorDialog(
                      context,
                      'password weak',
                    );
                  } else if (e.code == "invalid-email") {
                    await showErrorDialog(
                      context,
                      'enter an email',
                    );
                  } else {
                    await showErrorDialog(context, 'Error:${e.code}');
                  }
                } catch (e) {
                  await showErrorDialog(
                    context,
                    e.toString(),
                  );
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
