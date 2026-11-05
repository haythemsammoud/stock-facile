import 'package:sqflite/sqflite.dart';
import '../models/produit.dart';
import 'database_helper.dart';

class ProduitDao {
  static const String table = 'produits';

  Future<int> insererProduit(Produit produit) async {
    final Database db = await DatabaseHelper().database;
    final int id = await db.insert(table, produit.toMap());
    return id;
  }

  Future<List<Produit>> lireProduits() async {
    final db = await DatabaseHelper().database;
    final lignes = await db.query(table, orderBy: 'nom ASC');
    return lignes.map((ligne) => Produit.fromMap(ligne)).toList();
  }

  Future<Produit?> lireProduitParId(int id) async {
    final db = await DatabaseHelper().database;
    final lignes = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return lignes.isEmpty ? null : Produit.fromMap(lignes.first);
  }
  Future<int> modifierProduit(Produit produit) async {
  final db = await DatabaseHelper().database;
  return db.update(
    table,
    produit.toMap(),
    where: 'id = ?',
    whereArgs: [produit.id],
  );
}
// Modifie UNE seule colonne : la Map ne contient que cette colonne
Future<int> changerDisponibilite(int id, bool disponible) async {
  final db = await DatabaseHelper().database;
  return db.update(
    table,
    {'disponible': disponible ? 1 : 0},
    where: 'id = ?',
    whereArgs: [id],
  );
}

// Le calcul est fait par SQLite, et refusé si la quantité deviendrait < 0
Future<int> ajusterQuantite(int id, int delta) async {
  final db = await DatabaseHelper().database;
  return db.rawUpdate(
    'UPDATE produits SET quantite = quantite + ? '
    'WHERE id = ? AND quantite + ? >= 0',
    [delta, id, delta],
  );
}
}