class Produit {
  final int? id;
  final String nom;
  final double prix;
  final int quantite;
  final bool disponible;
  final DateTime dateAjout;
  final int categorieId;

  const Produit({
    this.id,
    required this.nom,
    required this.prix,
    this.quantite = 0,
    this.disponible = true,
    required this.dateAjout,
    required this.categorieId,
  });

  factory Produit.fromMap(Map<String, dynamic> map) {
    return Produit(
      id: map['id'] as int?,
      nom: map['nom'] as String,
      prix: (map['prix'] as num).toDouble(),
      quantite: map['quantite'] as int,
      disponible: map['disponible'] == 1,
      dateAjout: DateTime.parse(map['date_ajout'] as String),
      categorieId: map['categorie_id'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'nom': nom,
      'prix': prix,
      'quantite': quantite,
      'disponible': disponible ? 1 : 0,          // bool → 0 / 1
      'date_ajout': dateAjout.toIso8601String(), // DateTime → texte ISO 8601
      'categorie_id': categorieId,               // camelCase → snake_case
    };
  }
Produit copyWith({
  int? id,
  String? nom,
  double? prix,
  int? quantite,
  bool? disponible,
  DateTime? dateAjout,
  int? categorieId,
}) {
  return Produit(
    id: id ?? this.id,
    nom: nom ?? this.nom,
    prix: prix ?? this.prix,
    quantite: quantite ?? this.quantite,
    disponible: disponible ?? this.disponible,
    dateAjout: dateAjout ?? this.dateAjout,
    categorieId: categorieId ?? this.categorieId,
  );
}
  @override
  String toString() =>
      'Produit(id: $id, nom: $nom, prix: $prix, quantite: $quantite)';
}