import 'package:flutter/material.dart';
import 'package:flutter_test_for_vs/constants/routes.dart';
import 'package:flutter_test_for_vs/services/auth/auth_service.dart';
import 'package:flutter_test_for_vs/services/auth/authexceptions.dart';
import 'package:flutter_test_for_vs/utilities/dialogs/error_dialog.dart';

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
                  final creds = AuthService.firebase().createUser(
                    email: email,
                    password: password,
                  );
                  // ignore: avoid_print
                  // devtools.log(creds.toString());
                  AuthService.firebase().sendEmailVerification();
                  Navigator.of(context).pushNamed(VerifyEmailRoute);
                } on EmailAlreadyInUseAuthException {
                  await showErrorDialog(
                    context,
                    'email already in use',
                  );
                } on WeakPasswordAuthException {
                  await showErrorDialog(
                    context,
                    'password weak',
                  );
                } on InvalidEmailAuthException {
                  await showErrorDialog(
                    context,
                    'enter an email',
                  );
                } on GerericAuthException {
                  await showErrorDialog(context, 'Filed to register');
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
