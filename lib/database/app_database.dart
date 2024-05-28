import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  final int version = 1;
  final String databaseName = 'collectioneer.db';
  final String tableName = "user_preferences";

  Database? _db;

  Future<Database> openDB() async {
    _db ??= await openDatabase(
      join(await getDatabasesPath(), databaseName),
      onCreate: (db, version) {
        String query = """
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY,
            user_token TEXT,
            user_id INTEGER,
            latest_active_community INTEGER
          )
        """;
        db.execute(query);
      },
      version: version,
    );
    return _db as Database;
  }
}