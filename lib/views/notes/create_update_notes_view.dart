import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_test_for_vs/constants/routes.dart';

import 'package:flutter_test_for_vs/services/auth/auth_service.dart';
import 'package:flutter_test_for_vs/utilities/dialogs/cannot_share.dart';

import 'package:flutter_test_for_vs/utilities/dialogs/get_arguments.dart';
import 'package:flutter_test_for_vs/services/cloud/cloud_note.dart';

import 'package:flutter_test_for_vs/services/cloud/cloud_exceptions.dart';
import 'package:flutter_test_for_vs/services/cloud/firebase_cloud_storage.dart';
import 'package:share_plus/share_plus.dart';

class CreateUpdateNotesView extends StatefulWidget {
  const CreateUpdateNotesView({super.key});

  @override
  State<CreateUpdateNotesView> createState() => _NewNotesViewState();
}

class _NewNotesViewState extends State<CreateUpdateNotesView> {
  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    _textController = TextEditingController();
    print("initllized part 2");
    print(_textController.text);
    super.initState();
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;

    final notes = await _notesService.updateNote(
      documentId: note.documentId,
      text: text,
    );
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<CloudNote> CreateorGetExistingNote(BuildContext context) async {
    final widgetnote = context.getArgument<CloudNote>();
    if (widgetnote != null) {
      _note = widgetnote;
      _textController.text = widgetnote.text;
      return widgetnote;
    }
    final existingnote = _note;

    if (existingnote != null) {
      return existingnote;
    }
    final currentuser = AuthService.firebase().currentUser!;
    final userId = currentuser.id;

    final newNote = await _notesService.createNewNote(ownerUserId: userId);

    _note = newNote;
    // log("${newNote}");
    return newNote;
  }

  void _deleteNoteIfTextisEmpty() {
    final note = _note;
    // log("deleted");
    if (_textController.text.isEmpty && note != null) {
      _notesService.deleteNote(documentId: note.documentId);
      // print("done");
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;

    // log(" not deleted");
    final text = _textController.text;
    // log(text);
    // log('${text.isNotEmpty}');
    // log('${note != null}');
    if (note != null && text.isNotEmpty) {
      try {
        await _notesService.updateNote(
          documentId: note.documentId,
          text: text,
        );
      } catch (e) {
        e.toString();
      }
      // log("all done ");
      // log('${note}');
      // log(text);

      // log('${note.documentId} heree');
    } else {
      // log("all not done ");
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextisEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("new note"),
        actions: [
          IconButton(
              onPressed: () async {
                final text = _textController.text;
                if (_note == null || text.isEmpty) {
                  showCannotShareEmptynotesdialog(context);
                } else {
                  Share.share(text);
                }
              },
              icon: Icon(Icons.share))
        ],
      ),
      body: FutureBuilder(
        future: CreateorGetExistingNote(context),
        builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              // _note = snapshot.data as CloudNote;
              _setupTextControllerListener();
              return TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(hintText: "Start typing here...."),
                maxLines: null,
              );

            default:
              return CircularProgressIndicator();
          }
        }),
      ),
    );
  }
}
