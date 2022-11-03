import 'package:flutter/cupertino.dart';

@immutable
class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CouldNoteCreateNewNotes implements Exception {}

class CouldNotGetAllNotesException implements Exception {}

class CouldNotUpdateAllNotesException implements Exception {}

class CouldNotDeleteNotesException implements Exception {}
