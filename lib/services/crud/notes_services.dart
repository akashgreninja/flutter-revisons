// import 'dart:async';
// import 'dart:developer';
// import 'package:flutter_test_for_vs/extensions/list/filter.dart';
// import 'package:flutter_test_for_vs/services/crud/crud_exceptions.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart' show join;
// import 'package:path_provider/path_provider.dart';

// class NotesService {
//   Database? _db;

//   List<DatabaseNotes> _notes = [];
//   DatabaseUser? _user;
//   static final NotesService _shared = NotesService._sharedinstance();

//   NotesService._sharedinstance() {
//     _notesStreamController =
//         StreamController<List<DatabaseNotes>>.broadcast(onListen: () {
//       _notesStreamController.sink.add(_notes);
//     });
//   }
// //we are creating a singleton so that when we call NotesService() the app does not crash !! and the factory just sends the notes The singleton pattern is a pattern used in object-oriented programming which ensures that a class has only one instance and also provides a global point of access to it so we create one instance and factory it

//   factory NotesService() => _shared;

//   //we went from   late final _notesStreamController =  StreamController<List<DatabaseNotes>>.broadcast(); to this Ibelow line because it does not hold value for more then one listners

//   late final StreamController<List<DatabaseNotes>> _notesStreamController;

//   Stream<List<DatabaseNotes>> get allnotes =>
//       _notesStreamController.stream.filter((note) {
//         final currentUser = _user;
//         log("${_user} him");
//         if (currentUser != null) {
//           return note.userId == currentUser.id;
//         } else {
//           log("we here");
//           throw UserShouldBeDefined();
//         }
//       });

//   Future<DatabaseUser> GetorCreateUser({
//     required String email,
//     bool SetAsCurrentUser = true,
//   }) async {
//     try {
//       log("check here");
//       final user = await getUser(email: email);
//       log("${user}fef");
//       if (SetAsCurrentUser) {
//         _user = user;
//         log("inhehhehehh");
//       }
//       return user;
//     } on CouldNotFindUser {
//       final createdUser = await addUser(email: email);
//       if (SetAsCurrentUser) {
//         _user = createdUser;
//       }

//       return createdUser;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<DatabaseUser> getUser({required String email}) async {
//     log("inside user 2.0");
//     await _IsDbOpen();
//     final db = _getDatabaseorthrow();
//     final finalrows = await db.query(
//       userTable,
//       limit: 1,
//       where: 'email=?',
//       whereArgs: [email.toLowerCase()],
//     );

//     if (finalrows.isEmpty) {
//       log("inside user 2.0 false");
//       throw CouldNotFindUser();
//     } else {
//       log("${DatabaseUser.fromRow(finalrows.first)}");
//       return DatabaseUser.fromRow(finalrows.first);
//     }
//   }

//   Future<void> _cachenotes() async {
//     final allnotes = await getallnotes();
//     print(allnotes);

//     _notes = allnotes.toList();
//     _notesStreamController.add(_notes);
//   }

//   Future<DatabaseNotes> updateNote({
//     required DatabaseNotes note,
//     required String text,
//   }) async {
//     await _IsDbOpen();
//     final db = _getDatabaseorthrow();
//     await getNote(id: note.id);
//     final updatedcount = await db.update(
//         noteTable,
//         {
//           textColumn: text,
//         },
//         where: 'id=?',
//         whereArgs: [note.id]);
//     if (updatedcount == 0) {
//       throw CouldNotUpdateNote();
//     } else {
//       final upadatednotes = await getNote(id: note.id);
//       _notes.removeWhere((element) => element.id == upadatednotes.id);
//       _notes.add(upadatednotes);
//       _notesStreamController.add(_notes);
//       return upadatednotes;
//     }
//   }

//   Future<Iterable<DatabaseNotes>> getallnotes() async {
//     await _IsDbOpen();
//     print("dbisopen");
//     final db = _getDatabaseorthrow();
//     final note = await db.query(
//       noteTable,
//     );
//     print(note);
//     print("${note.map((e) => DatabaseNotes.fromRow(e))} and");

//     return note.map((e) => DatabaseNotes.fromRow(e));
//   }

//   Future<DatabaseNotes> getNote({required int id}) async {
//     await _IsDbOpen();
//     final db = _getDatabaseorthrow();
//     log("we in gwt one func");
//     final note =
//         await db.query(noteTable, where: 'id=?', limit: 1, whereArgs: [id]);
//     if (note.isEmpty) {
//       throw CouldNotGetNote();
//     } else {
//       final notes = DatabaseNotes.fromRow(note.first);
//       _notes.removeWhere((notes) => notes.id == id);
//       _notes.add(notes);
//       _notesStreamController.add(_notes);
//       return notes;
//     }
//   }

//   Future<int> deleteallnotes() async {
//     await _IsDbOpen();
//     final db = _getDatabaseorthrow();
//     _notes = [];
//     _notesStreamController.add(_notes);
//     return await db.delete(noteTable);
//   }

//   Future<void> DeleteNote({required int id}) async {
//     await _IsDbOpen();
//     final db = _getDatabaseorthrow();
//     final deletedCount = await db.delete(
//       noteTable,
//       where: 'id=?',
//       whereArgs: [id],
//     );
//     if (deletedCount == 0) {
//       throw CouldNotDeleteNote();
//     } else {
//       _notes.removeWhere((note) => note.id == id);
//       _notesStreamController.add(_notes);
//     }
//   }

//   Future<DatabaseNotes> createnotes({required DatabaseUser owner}) async {
//     log("correct");
//     await _IsDbOpen();
//     // make sure that owner exists in the DB
//     final db = _getDatabaseorthrow();

//     log("correct");
//     final dbUser = await getUser(email: owner.email);
//     if (dbUser != owner) {
//       log("user not there man");
//       throw CouldNotFindUser();
//     }
//     const text = '';
//     final noteid =
//         await db.insert(noteTable, {UserIdColumn: owner.id, textColumn: text});
//     print(noteid);
//     print("added it");

//     final note = DatabaseNotes(
//       id: noteid,
//       userId: owner.id,
//       text: text,
//     );
//     _notes.add(note);

//     _notesStreamController.add(_notes);

//     return note;
//   }

//   Future<DatabaseUser> addUser({required String email}) async {
//     await _IsDbOpen();
//     final db = _getDatabaseorthrow();
//     final finalrows = await db.query(
//       userTable,
//       limit: 1,
//       where: 'email=?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (finalrows.isNotEmpty) {
//       throw UserAlreadyExists();
//     }
//     final userid = await db.insert(userTable, {
//       emailColumn: email.toLowerCase(),
//     });
//     log("added him");
//     return DatabaseUser(id: userid, email: email);
//   }

//   Future<void> deleteUser({required String email}) async {
//     await _IsDbOpen();
//     final db = _getDatabaseorthrow();
//     final deletedcount = await db
//         .delete(userTable, where: 'email=?', whereArgs: [email.toLowerCase()]);

//     if (deletedcount != 1) {
//       throw CouldNotDeleteUser();
//     }
//   }

//   Database _getDatabaseorthrow() {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseIsNotOpen();
//     } else {
//       return db;
//     }
//   }

//   Future<void> open() async {
//     if (_db != null) {
//       throw DatabaseAlreadyOpenException();
//     }
//     try {
//       final docspath = await getApplicationDocumentsDirectory();
//       final dbpath = join(docspath.path, dbName);
//       final db = await openDatabase(dbpath);
//       _db = db;

//       await db.execute(createUserTable);

//       await db.execute(createNoteTable);
//       print("created");
//       await _cachenotes();
//     } on MissingPlatformDirectoryException {
//       throw UnableToGetDocumentsDirectory();
//     }
//   }

//   Future<void> _IsDbOpen() async {
//     try {
//       await open();
//     } on DatabaseAlreadyOpenException {}
//   }

//   Future<void> close() async {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseIsNotOpen();
//     } else {
//       await db.close();
//       _db = null;
//     }
//   }
// }

// class DatabaseUser {
//   final int id;
//   final String email;

//   const DatabaseUser({
//     required this.id,
//     required this.email,
//   });

//   DatabaseUser.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         email = map[emailColumn] as String;

//   @override
//   String toString() => 'Person,ID=$id , email=$email';

//   @override
//   bool operator ==(covariant DatabaseUser other) => id == other.id;

//   @override
//   // TODO: implement hashCode
//   int get hashCode => id.hashCode;
// }

// class DatabaseNotes {
//   final int id;
//   final int userId;
//   final String text;

//   DatabaseNotes({
//     required this.id,
//     required this.userId,
//     required this.text,
//   });

//   DatabaseNotes.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         userId = map[UserIdColumn] as int,
//         text = map[textColumn] as String;

//   @override
//   String toString() => 'Note,ID=$id , UserId=$userId,text=$text';

//   @override
//   bool operator ==(covariant DatabaseNotes other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }

// const dbName = 'notecrs.db';
// const noteTable = 'notes';
// const userTable = 'user';
// const idColumn = 'id';
// const emailColumn = "email";
// const UserIdColumn = "userId";
// const textColumn = 'text';
// const createNoteTable = ''' CREATE TABLE IF NOT EXISTS "notes" (
// 	"id"	INTEGER NOT NULL,
// 	"userId"	INTEGER NOT NULL,
// 	"text"	TEXT,
// 	PRIMARY KEY("id"),
// 	FOREIGN KEY("userId") REFERENCES "user"("id")
// );
//       ''';

// const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
// 	"id"	INTEGER NOT NULL,
// 	"email"	INTEGER NOT NULL UNIQUE,
// 	PRIMARY KEY("id" AUTOINCREMENT)
// );
//       ''';
