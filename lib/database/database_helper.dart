import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const String nomBase = 'stock_facile.db';

  // Version du SCHÉMA (à incrémenter quand on modifie les tables)
  static const int versionBase = 1;

  // 1. SINGLETON : une seule instance dans toute l'appli
  DatabaseHelper._interne();
  static final DatabaseHelper _instance = DatabaseHelper._interne();
  factory DatabaseHelper() => _instance;

  static Database? _db;

  // 2. OUVERTURE PARESSEUSE : on ouvre la base au premier besoin
  Future<Database> get database async {
    _db ??= await _ouvrirBase();
    return _db!;
  }

  // 3. OUVERTURE DU FICHIER (création s'il n'existe pas)
  Future<Database> _ouvrirBase() async {
    final dossier = await getDatabasesPath();
    final chemin = join(dossier, nomBase);
    debugPrint('Base SQLite : $chemin');

    return openDatabase(
      chemin,
      version: versionBase,
      // À CHAQUE ouverture : activer les clés étrangères
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      // Une seule fois : quand le fichier .db n'existe pas encore
      onCreate: _creerTables,
    );
  }

  // 4. CRÉATION DES TABLES
  Future<void> _creerTables(Database db, int version) async {
    debugPrint('onCreate : création des tables (version $version)');

    await db.execute('''
      CREATE TABLE categories (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        nom         TEXT    NOT NULL UNIQUE,
        description TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE produits (
        id           INTEGER PRIMARY KEY AUTOINCREMENT,
        nom          TEXT    NOT NULL,
        prix         REAL    NOT NULL CHECK (prix >= 0),
        quantite     INTEGER NOT NULL DEFAULT 0 CHECK (quantite >= 0),
        disponible   INTEGER NOT NULL DEFAULT 1,
        date_ajout   TEXT    NOT NULL,
        categorie_id INTEGER NOT NULL,
        FOREIGN KEY (categorie_id) REFERENCES categories(id) ON DELETE RESTRICT
      )
    ''');

    // Catégories de départ
    const depart = [
      {'nom': 'Alimentation', 'description': 'Produits secs et conserves'},
      {'nom': 'Boissons', 'description': 'Eaux, jus et sodas'},
      {'nom': 'Hygiène', 'description': "Savons et produits d'entretien"},
      {'nom': 'Papeterie', 'description': 'Cahiers, stylos et fournitures'},
    ];
    for (final c in depart) {
      await db.insert('categories', c);
    }
  }

  // 5. FERMETURE
  Future<void> fermer() async {
    await _db?.close();
    _db = null;
  }
}