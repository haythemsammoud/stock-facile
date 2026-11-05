import 'package:sqflite/sqflite.dart';
import '../models/categorie.dart';
import 'database_helper.dart';

class CategorieDao {
  static const String table = 'categories';

  Future<int> insererCategorie(Categorie categorie) async {
    // 1. Récupère la connexion unique à la base
    final Database db = await DatabaseHelper().database;
    // 2. Transforme l'objet en Map et insère la ligne
    final int id = await db.insert(table, categorie.toMap());
    // 3. Retourne l'id généré par AUTOINCREMENT
    return id;
  }
  Future<List<Categorie>> lireCategories() async {
  final db = await DatabaseHelper().database;
  final lignes = await db.query(table, orderBy: 'nom ASC');
  return lignes.map((ligne) => Categorie.fromMap(ligne)).toList();
}
Future<Categorie?> lireCategorieParId(int id) async {
  final db = await DatabaseHelper().database;
  final lignes = await db.query(
    table,
    where: 'id = ?',
    whereArgs: [id],
    limit: 1,
  );
  return lignes.isEmpty ? null : Categorie.fromMap(lignes.first);
}
}