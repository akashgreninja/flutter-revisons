import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_for_vs/services/auth/auth_service.dart';
import 'package:flutter_test_for_vs/services/cloud/cloud_note.dart';
import 'package:flutter_test_for_vs/services/cloud/firebase_cloud_storage.dart';
import 'package:flutter_test_for_vs/services/crud/notes_services.dart';
import 'package:flutter_test_for_vs/utilities/dialogs/logout_dialog.dart';
import 'package:flutter_test_for_vs/views/notes/create_update_notes_view.dart';
import 'package:flutter_test_for_vs/views/notes/notes_list_view.dart';
import 'package:path/path.dart';
import '../../constants/routes.dart';
import '../../enums/menu.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  //! means force wrapping it as we know 100% we will get an user
  String get UserId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();

    // final notes = _notesService.getallnotes();
    // print(notes);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Notes"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  NewNoteRoute,
                );
              },
              icon: const Icon(Icons.add)),
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
      body: StreamBuilder(
        stream: _notesService.allnotes(ownerUserId: UserId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allnotes = snapshot.data as Iterable<CloudNote>;
                log("${allnotes}");
                return NotesListView(
                  notes: allnotes,
                  onDeletenote: (note) async {
                    await _notesService.deleteNote(documentId: note.documentId);
                  },
                  onTap: (note) {
                    Navigator.of(context)
                        .pushNamed(NewNoteRoute, arguments: note);
                  },
                );
              } else {
                log("no data");
                return const CircularProgressIndicator();
              }

            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
