ElevatedButton(
  onPressed: () async {
    final db = await DatabaseHelper().database;
    final resultat = await db.rawQuery('SELECT COUNT(*) AS nb FROM categories');
    debugPrint('Nombre de catégories : ${resultat.first['nb']}');
  },
  child: const Text('Ouvrir la base'),
),