import 'package:flutter/material.dart';
import '../database/produit_dao.dart';
import '../models/produit.dart';
import '../widgets/produit_tile.dart';
import 'produit_detail_screen.dart';
import 'produit_form_screen.dart';

class ProduitsScreen extends StatefulWidget {
  const ProduitsScreen({super.key});

  @override
  State<ProduitsScreen> createState() => _ProduitsScreenState();
}

class _ProduitsScreenState extends State<ProduitsScreen> {
  final ProduitDao _dao = ProduitDao();
  late Future<List<Produit>> _futurProduits;

  @override
  void initState() {
    super.initState();
    _futurProduits = _dao.lireProduits();
  }

  Future<void> _rafraichir() async {
    final futur = _dao.lireProduits();
    setState(() {
      _futurProduits = futur;
    });
    await futur;
  }

  Future<void> _ouvrirDetail(Produit produit) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProduitDetailScreen(produitId: produit.id!),
      ),
    );
    if (!mounted) return;
    _rafraichir();
  }

  // Ouvre le formulaire d'ajout
  Future<void> _ajouter() async {
    final ajoute = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const ProduitFormScreen()),
    );
    if (!mounted) return;
    if (ajoute == true) {
      _rafraichir();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produit ajouté')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Produits')),
      floatingActionButton: FloatingActionButton(
        onPressed: _ajouter,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Produit>>(
        future: _futurProduits,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Erreur : ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          final produits = snapshot.data ?? [];

          if (produits.isEmpty) {
            return RefreshIndicator(
              onRefresh: _rafraichir,
              child: ListView(
                children: const [
                  SizedBox(height: 120),
                  Icon(Icons.inventory_2_outlined, size: 64),
                  SizedBox(height: 12),
                  Center(child: Text('Aucun produit')),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _rafraichir,
            child: ListView.builder(
              itemCount: produits.length,
              itemBuilder: (context, index) {
                final produit = produits[index];
                return ProduitTile(
                  produit: produit,
                  onTap: () => _ouvrirDetail(produit),
                );
              },
            ),
          );
        },
      ),
    );
  }
}