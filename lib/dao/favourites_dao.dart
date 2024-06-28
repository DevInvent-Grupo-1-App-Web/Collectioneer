import 'package:collectioneer/database/app_database.dart';
import 'package:collectioneer/models/element_type.dart';
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
        whereArgs: [elementId, elementType.toString()]);
    return result.isNotEmpty;
  }

  removeFavourite(int elementId, ElementType elementType) async {
    Database db = await AppDatabase().openDB();
    db.delete(tableName,
        where: 'element_id = ? AND element_type = ?',
        whereArgs: [elementId, elementType.toString()]);
  }

  addFavourite (int elementId, ElementType elementType) async {
    Database db = await AppDatabase().openDB();
    db.insert(tableName, {'element_id': elementId, 'element_type': elementType.toString()},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<FavouriteItem>> getFavourites() async {
  Database db = await AppDatabase().openDB();
  List<Map<String, dynamic>> result = await db.query(tableName);
  return result.map((item) => FavouriteItem(
    elementId: item['element_id'].toString(),
    elementType: castElementType(item['element_type']),
  )).toList();
}
}

class FavouriteItem {
  final String elementId;
  final ElementType elementType;

  FavouriteItem({required this.elementId, required this.elementType});
}