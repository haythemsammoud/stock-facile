import 'package:flutter/material.dart';
import '../database/categorie_dao.dart';
import '../database/produit_dao.dart';
import '../models/categorie.dart';
import '../models/produit.dart';

class ProduitFormScreen extends StatefulWidget {
  final Produit? produit; // null = ajout, non null = modification

  const ProduitFormScreen({super.key, this.produit});

  @override
  State<ProduitFormScreen> createState() => _ProduitFormScreenState();
}

class _ProduitFormScreenState extends State<ProduitFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomCtrl = TextEditingController();
  final _prixCtrl = TextEditingController();
  final _quantiteCtrl = TextEditingController();

  List<Categorie> _categories = [];
  int? _categorieId;
  bool _disponible = true;

  bool get _modeModification => widget.produit != null;

  @override
  void initState() {
    super.initState();
    // Mode modification : pré-remplir les champs
    final p = widget.produit;
    if (p != null) {
      _nomCtrl.text = p.nom;
      _prixCtrl.text = p.prix.toString();
      _quantiteCtrl.text = p.quantite.toString();
      _categorieId = p.categorieId;
      _disponible = p.disponible;
    }
    _chargerCategories();
  }

  Future<void> _chargerCategories() async {
    final categories = await CategorieDao().lireCategories();
    if (!mounted) return;
    setState(() {
      _categories = categories;
    });
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _prixCtrl.dispose();
    _quantiteCtrl.dispose();
    super.dispose();
  }

  Future<void> _enregistrer() async {
    if (!_formKey.currentState!.validate()) return;

    final nom = _nomCtrl.text.trim();
    final prix = double.parse(_prixCtrl.text.trim().replaceAll(',', '.'));
    final quantite = int.parse(_quantiteCtrl.text.trim());

    try {
      if (_modeModification) {
        // On garde l'id et la date d'ajout d'origine
        final modifie = widget.produit!.copyWith(
          nom: nom,
          prix: prix,
          quantite: quantite,
          disponible: _disponible,
          categorieId: _categorieId,
        );
        await ProduitDao().modifierProduit(modifie);
      } else {
        final nouveau = Produit(
          nom: nom,
          prix: prix,
          quantite: quantite,
          disponible: _disponible,
          dateAjout: DateTime.now(),
          categorieId: _categorieId!,
        );
        await ProduitDao().insererProduit(nouveau);
      }

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // La valeur n'est transmise au menu que si sa catégorie est déjà chargée
    final valeurMenu =
        _categories.any((c) => c.id == _categorieId) ? _categorieId : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _modeModification ? 'Modifier le produit' : 'Nouveau produit',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nom',
                  border: OutlineInputBorder(),
                ),
                validator: (valeur) {
                  if (valeur == null || valeur.trim().length < 2) {
                    return 'Au moins 2 caractères';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _prixCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Prix (DT)',
                  border: OutlineInputBorder(),
                ),
                validator: (valeur) {
                  final prix = double.tryParse(
                    (valeur ?? '').trim().replaceAll(',', '.'),
                  );
                  if (prix == null || prix < 0) {
                    return 'Entrez un prix valide (≥ 0)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantiteCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantité',
                  border: OutlineInputBorder(),
                ),
                validator: (valeur) {
                  final quantite = int.tryParse((valeur ?? '').trim());
                  if (quantite == null || quantite < 0) {
                    return 'Entrez un entier ≥ 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                // La clé reconstruit le champ quand les catégories arrivent
                key: ValueKey(_categories.length),
                initialValue: valeurMenu,
                decoration: const InputDecoration(
                  labelText: 'Catégorie',
                  border: OutlineInputBorder(),
                ),
                items: _categories
                    .map((c) => DropdownMenuItem<int>(
                          value: c.id,
                          child: Text(c.nom),
                        ))
                    .toList(),
                onChanged: (valeur) => setState(() => _categorieId = valeur),
                validator: (valeur) =>
                    valeur == null ? 'Choisissez une catégorie' : null,
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                title: const Text('Disponible à la vente'),
                value: _disponible,
                onChanged: (valeur) => setState(() => _disponible = valeur),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _enregistrer,
                  child: const Text('Enregistrer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}