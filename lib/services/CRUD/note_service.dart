import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

class DatabaseAlreadyOpenException implements Exception {}
class  UnableToGetDocumentsDirectoryException implements Exception{}
class DatabaseIsNotOpenException implements Exception{}

class NotesService {

  Database? _db;

  Database? _getDatabaseOrThrow() {
    final db = _db;
    if(db == null){
      throw DatabaseIsNotOpenException();
    }else {
      return db;
    }
  }

  Future<void> close() async {
    final db = _db;
    if(db == null){
      throw DatabaseIsNotOpenException();
    }else {
      await db.close();
      _db = null;
    }
  }

  Future<void> open() async {
    if(_db != null) {
      throw DatabaseAlreadyOpenException;
    }

    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
            "Id"	INTEGER NOT NULL,
            "email"	TEXT NOT NULL UNIQUE,
            PRIMARY KEY("Id" AUTOINCREMENT)
          );
          ''';

        await db.execute(createUserTable);

      const createNoteTable = '''CREATE TABLE IF NOT EXISTS "notes" (
            "id"	INTEGER NOT NULL,
            "user_id"	INTEGER NOT NULL,
            "text"	TEXT,
            "is_synced_with_cloud"	INTEGER DEFAULT 0,
            FOREIGN KEY("user_id") REFERENCES "user"("email"),
            PRIMARY KEY("id" AUTOINCREMENT)
          );
          ''';

        await db.execute(createNoteTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectoryException();
    }
  }
}

@immutable
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
  String toString() => 'Person, ID = $id, Email = $email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseNotes {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  const DatabaseNotes({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedWithCloud,
  });

  DatabaseNotes.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String,
        isSyncedWithCloud = (map[isSyncedWithCloudColumn] as int) == 1? true: false;

  @override
  String toString() => 'Note, ID = $id, userId = $userId, text = $text, isSyncedWithCloud = $isSyncedWithCloud';

  @override
  bool operator ==(covariant DatabaseNotes other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const dbName = 'flutter.db';
const noteTable = 'note';
const userTable = 'user';
const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = 'userId';
const textColumn = 'text';
const isSyncedWithCloudColumn = 'is_synced_with_cloud';
