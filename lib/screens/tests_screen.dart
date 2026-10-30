ElevatedButton(
  onPressed: () async {
    final db = await DatabaseHelper().database;
    final resultat = await db.rawQuery('SELECT COUNT(*) AS nb FROM categories');
    debugPrint('Nombre de catégories : ${resultat.first['nb']}');
  },
  child: const Text('Ouvrir la base'),
),
_bouton('Test : prix du produit 1 + 1 DT', () async {
            final p = await produitDao.lireProduitParId(1);
            if (p == null) return;
            final n = await produitDao.modifierProduit(p.copyWith(prix: p.prix + 1));
            debugPrint('Lignes modifiées : $n');
          }),