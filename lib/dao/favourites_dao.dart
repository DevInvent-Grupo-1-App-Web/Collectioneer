import 'package:collectioneer/database/app_database.dart';
import 'package:sqflite/sqflite.dart';

class FavouritesDao {
  final String tableName = "favourites";
  static final FavouritesDao _favouritesDao = FavouritesDao._internal();

  FavouritesDao._internal();

  factory FavouritesDao() {
    return _favouritesDao;
  }

  isFavourite(int elementId, ElementType elementType) async {
    Database db = await AppDatabase().openDB();
    List<Map<String, dynamic>> result = await db.query(tableName,
        where: 'element_id = ? AND element_type = ?',
        whereArgs: [elementId, elementType]);
    return result.isNotEmpty;
  }
}