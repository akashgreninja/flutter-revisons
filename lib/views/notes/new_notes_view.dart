import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_test_for_vs/services/auth/auth_service.dart';
import 'package:flutter_test_for_vs/services/crud/notes_services.dart';

class NewNotesView extends StatefulWidget {
  const NewNotesView({super.key});

  @override
  State<NewNotesView> createState() => _NewNotesViewState();
}

class _NewNotesViewState extends State<NewNotesView> {
  DatabaseNotes? _note;
  late final NotesService _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _notesService = NotesService();
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
    print("sasasasasasas{$text}");
    await _notesService.updateNote(
      note: note,
      text: text,
    );
    print("sasasasasasas{$text}");
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
    print("added listner");
  }

  Future<DatabaseNotes> createnewNote() async {
    final existingnote = _note;

    if (existingnote != null) {
      return existingnote;
    }
    final currentuser = AuthService.firebase().currentUser!;
    log("${currentuser} dnwjdwjwdwbwj");
    final email = currentuser.email!;
    log("${email} doneeee");
    final owner = await _notesService.GetorCreateUser(email: email);
    log("${owner} owner here");
    try {
      log("sucessfully in");
      return await _notesService.createnotes(owner: owner);
    } catch (e) {
      log(e.toString());
      return _notesService.createnotes(owner: owner);
    }
  }

  void _deleteNoteIfTextisEmpty() {
    final note = _note;
    log("deleted");
    if (_textController.text.isEmpty && note != null) {
      _notesService.DeleteNote(id: note.id);
      print("done");
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    log(" not deleted");
    final text = _textController.text;
    log(text);
    log('${text.isNotEmpty}');
    log('${note != null}');
    if (text.isNotEmpty) {
      log("all done ");
      log('${note}');
      log(text);

      final rsults = await _notesService.updateNote(note: note!, text: text);
      log("${rsults} here is the ans");
    } else {
      log("all not done ");
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
      appBar: AppBar(title: const Text("new note")),
      body: FutureBuilder(
        future: createnewNote(),
        builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _note = snapshot.data as DatabaseNotes?;
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
