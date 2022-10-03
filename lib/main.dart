import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_for_vs/views/VerifyEmailView.dart';

import 'package:flutter_test_for_vs/views/login_view.dart';
import 'package:flutter_test_for_vs/views/register_view.dart';

import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      home: const LoginView(),
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView()
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;

            if (user?.emailVerified ?? false) {
              return const Text("done");
            } else {
              // now the problem with flutter is when we use future builder it requires something like a component to be rendered on screen but as we are completely pushing a different screen it causes that error so we have removed it

              // Navigator.of(context).push(
              //     MaterialPageRoute(builder: (context) => VerifyEmail()));
              return const VerifyEmail();
            }

          default:
            return CircularProgressIndicator();
        }
      },
    );
  }
}
