// Q4.7
  Future<int> insererProduit(Produit produit) async {
    final db = await DatabaseHelper().database;
    return db.insert(table, produit.toMap());
  }