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
// CategorieDao
Future<List<Categorie>> lireCategories() async {
  final db = await DatabaseHelper().database;
  final lignes = await db.query(table, orderBy: 'nom ASC');
  return lignes.map((ligne) => Categorie.fromMap(ligne)).toList();
}