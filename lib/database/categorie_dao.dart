import 'package:sqflite/sqflite.dart';
import '../models/categorie.dart';
import 'database_helper.dart';

class CategorieDao {
  static const String table = 'categories';

  Future<int> insererCategorie(Categorie categorie) async {
    final Database db = await DatabaseHelper().database;
    final int id = await db.insert(table, categorie.toMap());
    return id;
  }
}
