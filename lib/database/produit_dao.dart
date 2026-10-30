// Q4.7
  Future<int> insererProduit(Produit produit) async {
    final db = await DatabaseHelper().database;
    return db.insert(table, produit.toMap());
  }
  // ProduitDao – indice pour lireProduitParId
final lignes = await db.query(
  table,
  where: 'id = ?',
  whereArgs: [id],
  limit: 1,
);
return lignes.isEmpty ? null : Produit.fromMap(lignes.first);