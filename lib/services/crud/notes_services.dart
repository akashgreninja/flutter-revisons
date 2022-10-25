import 'package:flutter_test_for_vs/services/crud/crud_exceptions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

class NotesService {
  Database? _db;

  Future<DatabaseNotes> updateNote({
    required DatabaseNotes note,
    required String text,
  }) async {
    final db = _getDatabaseorthrow();
    await getNote(id: note.id);
    final updatedcount = await db.update(noteTable, {
      textColumn: text,
    });
    if (updatedcount == 0) {
      throw CouldNotUpdateNote();
    } else {
      return await getNote(id: note.id);
    }
  }

  Future<Iterable<DatabaseNotes>> getallnotes() async {
    final db = _getDatabaseorthrow();
    final note = await db.query(
      noteTable,
    );

    return note.map((e) => DatabaseNotes.fromRow(e));
  }

  Future<DatabaseNotes> getNote({required int id}) async {
    final db = _getDatabaseorthrow();
    final note =
        await db.query(noteTable, where: 'id=?', limit: 1, whereArgs: [id]);
    if (note.isEmpty) {
      throw CouldNotGetNote();
    } else {
      return DatabaseNotes.fromRow(note.first);
    }
  }

  Future<int> deleteallnotes() async {
    final db = _getDatabaseorthrow();
    return await db.delete(noteTable);
  }

  Future<void> DeleteNote({required int id}) async {
    final db = _getDatabaseorthrow();
    final deletedCount = await db.delete(
      noteTable,
      where: 'id=?',
      whereArgs: [id],
    );
    if (deletedCount == 0) {
      throw CouldNotDeleteNote();
    }
  }

  Future<DatabaseNotes> createnotes({required DatabaseUser owner}) async {
    // make sure that owner exists in the DB
    final db = _getDatabaseorthrow();
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFindUser();
    }
    const text = '';
    final noteid =
        await db.insert(noteTable, {UserIdColumn: owner.id, textColumn: text});

    final note = DatabaseNotes(
      id: noteid,
      userId: owner.id,
      text: text,
    );
    return note;
  }

  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDatabaseorthrow();
    final finalrows = await db.query(
      userTable,
      limit: 1,
      where: 'email=?',
      whereArgs: [email.toLowerCase()],
    );
    if (finalrows.isEmpty) {
      throw CouldNotFindUser();
    } else {
      return DatabaseUser.fromRow(finalrows.first);
    }
  }

  Future<DatabaseUser> addUser({required String email}) async {
    final db = _getDatabaseorthrow();
    final finalrows = await db.query(
      userTable,
      limit: 1,
      where: 'email=?',
      whereArgs: [email.toLowerCase()],
    );
    if (finalrows.isNotEmpty) {
      throw UserAlreadyExists();
    }
    final userid = await db.insert(userTable, {
      emailColumn: email.toLowerCase(),
    });
    return DatabaseUser(id: userid, email: email);
  }

  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseorthrow();
    final deletedcount = await db
        .delete(userTable, where: 'email=?', whereArgs: [email.toLowerCase()]);

    if (deletedcount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  Database _getDatabaseorthrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docspath = await getApplicationDocumentsDirectory();
      final dbpath = join(docspath.path, dbName);
      final db = await openDatabase(dbpath);
      _db = db;

      await db.execute(createUserTable);

      await db.execute(createNoteTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }
}

class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({
    required this.id,
    required this.email,
  });

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => 'Person,ID=$id , email=$email';
  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  // TODO: implement hashCode
  int get hashCode => id.hashCode;
}

class DatabaseNotes {
  final int id;
  final int userId;
  final String text;

  DatabaseNotes({
    required this.id,
    required this.userId,
    required this.text,
  });

  DatabaseNotes.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[UserIdColumn] as int,
        text = map[textColumn] as String;

  @override
  String toString() => 'Note,ID=$id , UserId=$userId,text=$text';

  @override
  bool operator ==(covariant DatabaseNotes other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const dbName = 'notes.db';
const noteTable = 'notes';
const userTable = 'user';
const idColumn = 'id';
const emailColumn = "email";
const UserIdColumn = "user_id";
const textColumn = 'text';
const createNoteTable = ''' CREATE TABLE IF NOT EXISTS "notes" (
      "id"	INTEGER NOT NULL,
      "userId"	INTEGER NOT NULL,
      "text"	TEXT,
      FOREIGN KEY("userId") REFERENCES "user"("id"),
      PRIMARY KEY("id")
);
      ''';

const createUserTable = ''' CREATE TABLE  IF NOT EXISTS "user"(
      "id"	INTEGER NOT NULL,
      "email"	INTEGER NOT NULL UNIQUE,
      PRIMARY KEY("id" AUTOINCREMENT)
);
      ''';
