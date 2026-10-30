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
Future<int> changerDisponibilite(int id, bool disponible) async {
  final db = await DatabaseHelper().database;
  return db.update(
    table,
    {'disponible': disponible ? 1 : 0},
    where: 'id = ?',
    whereArgs: [id],
  );
}
$Future<int> ajusterQuantite(int id, int delta) async {
  final db = await DatabaseHelper().database;
  return db.rawUpdate(
    'UPDATE produits SET quantite = quantite + ? '
    'WHERE id = ? AND quantite + ? >= 0',
    [delta, id, delta],
  );
}