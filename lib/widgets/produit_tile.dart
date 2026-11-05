import 'package:flutter/material.dart';
import '../models/produit.dart';

class ProduitTile extends StatelessWidget {
  final Produit produit;
  final VoidCallback onTap;

  const ProduitTile({super.key, required this.produit, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor:
            produit.quantite == 0 ? Colors.red : Colors.green,
        foregroundColor: Colors.white,
        child: Text('${produit.quantite}'),
      ),
      title: Text(produit.nom),
      subtitle: Text('${produit.prix.toStringAsFixed(3)} DT'),
      trailing: Icon(
        produit.disponible ? Icons.check_circle : Icons.cancel,
        color: produit.disponible ? Colors.green : Colors.red,
      ),
    );
  }
}