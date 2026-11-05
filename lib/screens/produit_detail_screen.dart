import 'package:flutter/material.dart';
import '../database/categorie_dao.dart';
import '../database/produit_dao.dart';
import '../models/categorie.dart';
import '../models/produit.dart';
import 'produit_form_screen.dart';

class ProduitDetailScreen extends StatefulWidget {
  final int produitId;

  const ProduitDetailScreen({super.key, required this.produitId});

  @override
  State<ProduitDetailScreen> createState() => _ProduitDetailScreenState();
}

class _ProduitDetailScreenState extends State<ProduitDetailScreen> {
  final ProduitDao _dao = ProduitDao();
  late Future<_DetailData?> _futurDetail;
  bool _modifie = false; // renvoyé à la liste en quittant l'écran

  @override
  void initState() {
    super.initState();
    _futurDetail = _charger();
  }

  Future<_DetailData?> _charger() async {
    final produit = await _dao.lireProduitParId(widget.produitId);
    if (produit == null) return null;
    final categorie =
        await CategorieDao().lireCategorieParId(produit.categorieId);
    return _DetailData(produit, categorie);
  }

  void _recharger() {
    setState(() {
      _futurDetail = _charger();
    });
  }

  Future<void> _modifier(Produit produit) async {
    final resultat = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => ProduitFormScreen(produit: produit)),
    );
    if (!mounted) return;
    if (resultat == true) {
      _modifie = true;
      _recharger();
    }
  }

  // Q6.16 + Q6.17 : ajuster la quantité de delta (+1 ou -1)
  Future<void> _ajuster(int delta) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final lignes = await _dao.ajusterQuantite(widget.produitId, delta);

      if (lignes == 0) {
        // La quantité serait devenue négative : SQLite a refusé
        messenger.showSnackBar(
          const SnackBar(content: Text('La quantité ne peut pas être négative')),
        );
        return;
      }

      _modifie = true;

      // Q6.17 : quantité à 0 -> produit indisponible automatiquement
      final produit = await _dao.lireProduitParId(widget.produitId);
      if (produit != null && produit.quantite == 0 && produit.disponible) {
        await _dao.changerDisponibilite(widget.produitId, false);
      }

      if (!mounted) return;
      _recharger();
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('ERREUR : $e')));
    }
  }

  String _formatDate(DateTime d) {
    final jj = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$jj/$mm/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context, _modifie);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Détail du produit'),
          actions: [
            FutureBuilder<_DetailData?>(
              future: _futurDetail,
              builder: (context, snapshot) {
                final detail = snapshot.data;
                if (detail == null) return const SizedBox.shrink();
                return IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: 'Modifier',
                  onPressed: () => _modifier(detail.produit),
                );
              },
            ),
          ],
        ),
        body: FutureBuilder<_DetailData?>(
          future: _futurDetail,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Erreur : ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            final detail = snapshot.data;
            if (detail == null) {
              return const Center(child: Text('Produit introuvable'));
            }
            final p = detail.produit;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.nom,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 16),
                          Text('Prix : ${p.prix.toStringAsFixed(3)} DT'),
                          Text('Quantité : ${p.quantite}'),
                          Text('Disponible : ${p.disponible ? 'Oui' : 'Non'}'),
                          Text(
                            'Catégorie : ${detail.categorie?.nom ?? 'Inconnue'}',
                          ),
                          Text('Ajouté le : ${_formatDate(p.dateAjout)}'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Boutons − et +
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton.filledTonal(
                        icon: const Icon(Icons.remove),
                        tooltip: 'Retirer 1',
                        onPressed: () => _ajuster(-1),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          '${p.quantite}',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      IconButton.filledTonal(
                        icon: const Icon(Icons.add),
                        tooltip: 'Ajouter 1',
                        onPressed: () => _ajuster(1),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DetailData {
  final Produit produit;
  final Categorie? categorie;
  const _DetailData(this.produit, this.categorie);
}