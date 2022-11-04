import 'dart:developer';

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
      log("${text} text to higher");
      await notes.doc(documentId).update({
        textFieldName: text,
      });
    } catch (e) {
      log("in the exp");
      throw CouldNotUpdateAllNotesException();
    }
  }

  Stream<Iterable<CloudNote>> allnotes({required String ownerUserId}) {
    try {
      return notes.snapshots().map((event) => event.docs
          .map((e) => CloudNote.fromSnapshot(e))
          .where((note) => note.ownerUserId == ownerUserId));
    } catch (e) {
      e.toString();
      return notes.snapshots().map((event) => event.docs
          .map((e) => CloudNote.fromSnapshot(e))
          .where((note) => note.ownerUserId == ownerUserId));
    }
  }

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      // log("we in again");
      return await notes
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
            (value) => value.docs.map(
              (e) => CloudNote.fromSnapshot(e),
            ),
          );
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
    final fetchNote = await document.get();
    return CloudNote(
      documentId: fetchNote.id,
      ownerUserId: ownerUserId,
      text: '',
    );
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedinstance();

  FirebaseCloudStorage._sharedinstance();
  factory FirebaseCloudStorage() => _shared;
}
