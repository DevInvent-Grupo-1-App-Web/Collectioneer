import 'package:collectioneer/database/app_database.dart';
import 'package:sqflite/sqflite.dart';

class PostDao {
  final String tableName = "posts";
  static final PostDao _postDao = PostDao._internal();

  PostDao._internal();

  factory PostDao() {
    return _postDao;
  }
  
  fetch() async {
    Database db = await AppDatabase().openDB();
    return db.query(tableName);
  }

  insert(String title, String content) async {
    Database db = await AppDatabase().openDB();
    db.insert(tableName, {'title': title, 'content': content},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  delete() async {
    Database db = await AppDatabase().openDB();
    db.delete(tableName, where: 'id = ?', whereArgs: [1]);
  }
}
