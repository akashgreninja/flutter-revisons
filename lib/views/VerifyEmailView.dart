import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_for_vs/constants/routes.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verify email?")),
      body: Column(
        children: [
          const Text("we have already sent you an email please check it "),
          const Text("if you havent recieved it then click below"),
          TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
            },
            child: const Text("Send Email Verification"),
          ),
          TextButton(
              onPressed: () async {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    registerRoute, (Route<dynamic> route) => false);
              },
              child: Text("restart"))
        ],
      ),
    );
  }
}
