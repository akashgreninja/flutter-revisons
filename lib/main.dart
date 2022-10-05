import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_for_vs/views/VerifyEmailView.dart';
import 'dart:developer' as devtools show log;
import 'package:flutter_test_for_vs/views/login_view.dart';
import 'package:flutter_test_for_vs/views/register_view.dart';

import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      home: const HomePage(),
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
              if (user.emailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmail();
              }
            } else {
              return const LoginView();
            }
            return const Text("done");
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

enum MenuAction { logout }

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes here"),
        actions: [
          PopupMenuButton<MenuAction>(onSelected: (value) async {
            devtools.log(value.toString());
            switch (value) {
              case MenuAction.logout:
                final shouldlogout = await showLogoutDialog(context);
                if (shouldlogout) {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login/', (Route<dynamic> route) => false);
                }
                devtools.log(shouldlogout.toString());

                break;
              default:
            }
          }, itemBuilder: (context) {
            return [
              const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout, child: Text("logout"))
            ];
          })
        ],
      ),
      body: const Text(("hello world")),
    );
  }
}

Future<bool> showLogoutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: ((context) {
        return AlertDialog(
          title: Text("loggedout"),
          content: Text("Are you sure you want to log out"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text("Cancel")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text("Logout"))
          ],
        );
      })).then((value) => value ?? false);
}
