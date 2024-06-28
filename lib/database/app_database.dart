import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  final int version = 1;
  final String databaseName = 'collectioneer.db';
  final List<String> tablesName = ['posts', 'favourites'];

  Database? _db;

  Future<Database> openDB() async {
    _db ??= await openDatabase(
      join(await getDatabasesPath(), databaseName),
      onCreate: (db, version) {
        String query = """
          CREATE TABLE ${tablesName[0]} (
            id INTEGER PRIMARY KEY,
            title TEXT,
            content TEXT
          )
        """;
        db.execute(query);

        query = """
          CREATE TABLE ${tablesName[1]} (
            id INTEGER PRIMARY KEY,
            element_id INTEGER,
            element_type TEXT
          )
        """;
        db.execute(query);
      },
      version: version,
    );
    return _db as Database;
  }
}