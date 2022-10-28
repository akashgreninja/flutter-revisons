import 'package:flutter/material.dart';
import 'package:flutter_test_for_vs/constants/routes.dart';
import 'package:flutter_test_for_vs/services/auth/auth_service.dart';
import 'package:flutter_test_for_vs/views/notes/NotesView.dart';
import 'package:flutter_test_for_vs/views/VerifyEmailView.dart';
import 'dart:developer' as devtools show log;
import 'package:flutter_test_for_vs/views/login_view.dart';
import 'package:flutter_test_for_vs/views/notes/new_notes_view.dart';
import 'package:flutter_test_for_vs/views/register_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notes: (context) => const NotesView(),
        VerifyEmailRoute: (context) => const VerifyEmail(),
        NewNoteRoute: (context) => const NewNotesView()
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;

            // now the problem with flutter is when we use future builder it requires something like a component to be rendered on screen but as we are completely pushing a different screen it causes that error so we have removed it

            // Navigator.of(context).push(
            //     MaterialPageRoute(builder: (context) => VerifyEmail()));

            // You can use this or
            // if (user?.emailVerified ?? false) {
            //   return const Text("email verified");
            // } else {
            //   return const VerifyEmail();
            // }

            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmail();
              }
            } else {
              return const LoginView();
            }

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
