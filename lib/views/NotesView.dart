import 'package:flutter/material.dart';
import 'package:flutter_test_for_vs/services/auth/auth_service.dart';
import '../constants/routes.dart';
import '../enums/menu.dart';

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
            // devtools.log(value.toString());
            switch (value) {
              case MenuAction.logout:
                final shouldlogout = await showLogoutDialog(context);
                if (shouldlogout) {
                  AuthService.firebase().logOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute, (Route<dynamic> route) => false);
                }
                // devtools.log(shouldlogout.toString());

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
