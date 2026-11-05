import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../database/categorie_dao.dart';
import '../database/database_helper.dart';
import '../database/produit_dao.dart';
import '../models/categorie.dart';
import '../models/produit.dart';
import 'produits_screen.dart';

class TestsScreen extends StatelessWidget {
  const TestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StockFacile : tests')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ---------- Partie 03 : ouvrir la base ----------
          ElevatedButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              try {
                final db = await DatabaseHelper().database;
                final resultat =
                    await db.rawQuery('SELECT COUNT(*) AS nb FROM categories');
                final message = 'Chemin : ${db.path}\n'
                    'Nombre de catégories : ${resultat.first['nb']}';
                debugPrint(message);
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(message),
                    duration: const Duration(seconds: 8),
                  ),
                );
              } catch (e) {
                debugPrint('ERREUR : $e');
                messenger.showSnackBar(SnackBar(content: Text('ERREUR : $e')));
              }
            },
            child: const Text('Ouvrir la base'),
          ),

          // ---------- Partie 04 : insérer une catégorie ----------
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              const nouvelle = Categorie(
                nom: 'Électroménager',
                description: 'Petits appareils',
              );
              try {
                final id = await CategorieDao().insererCategorie(nouvelle);
                debugPrint('Catégorie insérée avec l\'id $id');
                messenger.showSnackBar(
                  SnackBar(content: Text('Catégorie insérée avec l\'id $id')),
                );
              } on DatabaseException catch (e) {
                if (e.isUniqueConstraintError()) {
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Cette catégorie existe déjà'),
                    ),
                  );
                } else {
                  messenger.showSnackBar(
                    SnackBar(content: Text('Erreur SQLite : $e')),
                  );
                }
              } catch (e) {
                messenger.showSnackBar(SnackBar(content: Text('ERREUR : $e')));
              }
            },
            child: const Text('Test : ajouter une catégorie'),
          ),

          // ---------- Partie 04 : insérer un produit ----------
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => _testerInsertion(
              context,
              Produit(
                nom: 'Stylo bleu',
                prix: 0.5,
                quantite: 100,
                dateAjout: DateTime.now(),
                categorieId: 4,
              ),
            ),
            child: const Text('Test : ajouter un produit'),
          ),

          // ---------- Q4.10 : catégorie inexistante ----------
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => _testerInsertion(
              context,
              Produit(
                nom: 'Test catégorie',
                prix: 1,
                quantite: 1,
                dateAjout: DateTime.now(),
                categorieId: 99,
              ),
            ),
            child: const Text('Test : catégorie inexistante (99)'),
          ),

          // ---------- Q4.11 : prix négatif ----------
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => _testerInsertion(
              context,
              Produit(
                nom: 'Test prix',
                prix: -2,
                quantite: 1,
                dateAjout: DateTime.now(),
                categorieId: 1,
              ),
            ),
            child: const Text('Test : prix négatif'),
          ),

          // ---------- Partie 05 : lire les produits ----------
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              try {
                final db = await DatabaseHelper().database;
                // a) lecture brute, sans conversion
                final lignes = await db.query('produits');
                debugPrint('Type : ${lignes.runtimeType}');
                debugPrint('Brut : $lignes');
                // b) tentative de modification d'une ligne
                try {
                  lignes.first['nom'] = 'Test';
                } catch (e) {
                  messenger.showSnackBar(SnackBar(content: Text('b) $e')));
                }
                // c) avec conversion
                final produits = await ProduitDao().lireProduits();
                for (final p in produits) {
                  debugPrint(p.toString());
                }
              } catch (e) {
                messenger.showSnackBar(SnackBar(content: Text('ERREUR : $e')));
              }
            },
            child: const Text('Test : lire les produits'),
          ),

          // ---------- Q5.4 : lire par id ----------
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              try {
                final p1 = await ProduitDao().lireProduitParId(1);
                final p999 = await ProduitDao().lireProduitParId(999);
                messenger.showSnackBar(
                  SnackBar(content: Text('id 1 : $p1\nid 999 : $p999')),
                );
              } catch (e) {
                messenger.showSnackBar(SnackBar(content: Text('ERREUR : $e')));
              }
            },
            child: const Text('Test : lire par id (1 et 999)'),
          ),

          // ---------- Q5.8 : ouvrir la liste ----------
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProduitsScreen()),
            ),
            child: const Text('Ouvrir la liste des produits'),
          ),

          // ---------- Q6.12 : modifier le prix du produit 1 ----------
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              try {
                final dao = ProduitDao();
                final p = await dao.lireProduitParId(1);
                if (p == null) {
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Produit 1 introuvable')),
                  );
                  return;
                }
                final modifie = p.copyWith(prix: p.prix + 1);
                final lignes = await dao.modifierProduit(modifie);
                messenger.showSnackBar(
                  SnackBar(content: Text('Lignes modifiées : $lignes')),
                );
              } catch (e) {
                messenger.showSnackBar(SnackBar(content: Text('ERREUR : $e')));
              }
            },
            child: const Text('Test : prix du produit 1 + 1 DT'),
          ),
        ],
      ),
    );
  }

  // Insère un produit et affiche le résultat ou l'erreur dans un SnackBar
  Future<void> _testerInsertion(BuildContext context, Produit produit) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final id = await ProduitDao().insererProduit(produit);
      messenger.showSnackBar(
        SnackBar(content: Text('Produit inséré avec l\'id $id')),
      );
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('ERREUR : $e')));
    }
  }
}