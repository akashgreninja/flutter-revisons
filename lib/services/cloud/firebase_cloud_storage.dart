import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test_for_vs/services/cloud/cloud_constants.dart';
import 'package:flutter_test_for_vs/services/cloud/cloud_exceptions.dart';
import 'package:flutter_test_for_vs/services/cloud/cloud_note.dart';
import 'package:flutter_test_for_vs/services/crud/notes_services.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  Future<void> deleteNote({
    required String documentId,
  }) async {
    try {
      notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNotesException();
    }
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      notes.doc(documentId).update({
        textFieldName: text,
      });
    } catch (e) {
      throw CouldNotUpdateAllNotesException();
    }
  }

  Stream<Iterable<CloudNote>> allnotes({required String ownerUserId}) =>
      notes.snapshots().map((event) => event.docs
          .map((e) => CloudNote.fromSnapshot(e))
          .where((note) => note.ownerUserId == ownerUserId));

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
            (value) => value.docs.map((e) {
              return CloudNote(
                documentId: e.id,
                ownerUserId: e.data()[ownerUserIdFieldName],
                text: e.data()[textFieldName] as String,
              );
            }),
          );
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  void createNewNote({required String ownerUserId}) async {
    await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedinstance();

  FirebaseCloudStorage._sharedinstance();
  factory FirebaseCloudStorage() => _shared;
}
