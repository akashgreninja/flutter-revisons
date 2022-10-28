import 'package:flutter/material.dart';
import 'package:flutter_test_for_vs/services/crud/notes_services.dart';
import 'package:flutter_test_for_vs/utilities/dialogs/delete_dialog.dart';

typedef DeleteNotecallback = void Function(DatabaseNotes note);

class NotesListView extends StatelessWidget {
  final List<DatabaseNotes> notes;
  final DeleteNotecallback onDeletenote;
  const NotesListView(
      {super.key, required this.notes, required this.onDeletenote});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return Flexible(
          child: Column(children: [
            ListTile(
              title: Text(
                note.text,
                maxLines: 1,

                overflow: TextOverflow.ellipsis,
                softWrap: true,
                // style: TextStyle(
                //     color: Colors.black,
                //     fontWeight: FontWeight.bold,
                //     fontSize: 20.0),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  final shoulddelete = await showDeleteDialog(context);
                  if (shoulddelete) {
                    onDeletenote(note);
                  }
                },
              ),
            ),
          ]),
        );
      },
    );
  }
}
