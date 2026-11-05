## Q1.3

- **disponible et date_ajout** : SQLite n'a ni BOOLEAN ni DATETIME.
  `disponible` est stocké en entier (1 = vrai, 0 = faux) et `date_ajout`
  en texte au format ISO 8601 (ex. 2026-10-01T09:00:00).
- **AUTOINCREMENT** : l'id est généré automatiquement (1, 2, 3...) et un id
  supprimé n'est jamais réutilisé.
- **UNIQUE sur nom** : interdit deux catégories avec le même nom.
- **CHECK (prix >= 0)** : la base refuse tout prix négatif.
- **ON DELETE RESTRICT** : impossible de supprimer une catégorie tant que
  des produits y sont rattachés.

## Q1.6

- a) prix négatif : CHECK constraint failed ...
- b) catégorie inexistante : FOREIGN KEY constraint failed
- c) suppression d'une catégorie utilisée : FOREIGN KEY constraint failed

## Q1.7

`schema.sql` contient uniquement les instructions CREATE TABLE des deux
tables (structure, contraintes, clés étrangères), entourées de
BEGIN TRANSACTION / COMMIT. Il ne contient aucune donnée.

## Q1.8

Il faut fermer la base car deux programmes qui écrivent en même temps dans
le même fichier .db risquent de le verrouiller (erreur "database is locked")
ou de se marcher dessus et d'abîmer les données.

## Q2.3

- `id` est `int?` car un objet pas encore enregistré n'a pas d'id : c'est
  SQLite (AUTOINCREMENT) qui le génère à l'insertion.
- `toMap()` n'ajoute `id` que s'il n'est pas null pour laisser la base
  générer l'id lors d'un insert.

  ## Q3.2

- (1) Deux fois `DatabaseHelper()` renvoie le même objet : un seul est créé.
  Le constructeur `factory` ne crée pas forcément un nouvel objet, il
  retourne l'instance unique `_instance` (pattern singleton).
- (2) `??=` : si `_db` est null, on y met le résultat de l'ouverture ;
  sinon on garde la connexion existante.
- (3) `PRAGMA foreign_keys = ON` est dans `onConfigure` car SQLite le remet
  à OFF à chaque ouverture ; `onCreate` n'est appelé qu'une seule fois.
- (4) `onCreate` n'est appelé qu'une seule fois dans la vie de l'application :
  à la création du fichier .db.

## Q3.5

Au 2e lancement, `onCreate` ne s'affiche plus car le fichier stock_facile.db
existe déjà : sqflite n'appelle onCreate que si la base n'existe pas.

## Q3.7

User Version = 1 : elle correspond à `version: versionBase` (versionBase = 1)
passé à `openDatabase` dans DatabaseHelper. sqflite l'écrit dans le fichier
et la compare à chaque ouverture pour décider d'appeler onCreate ou onUpgrade.

## Q4.3

Le premier clic retourne l'id 5 : les ids 1 à 4 sont les catégories de départ,
AUTOINCREMENT attribue le suivant.

## Q4.4

Le deuxième clic lève : UNIQUE constraint failed: categories.nom.
C'est la contrainte UNIQUE sur la colonne nom (Partie 01) qui est en cause.

## Q4.9

`disponible` est stocké en 1/0 et `date_ajout` en texte ISO 8601. C'est
conforme à `toMap()` (bool → 0/1, DateTime → toIso8601String()).

## Q4.10

Avec foreign_keys = ON : FOREIGN KEY constraint failed. Sans le PRAGMA,
l'insertion réussit et crée un produit orphelin. Le hot reload ne suffit
pas car onConfigure ne s'exécute qu'à l'ouverture de la base.

## Q4.11

La contrainte CHECK (prix >= 0) bloque l'insertion. Il faut aussi vérifier
le prix dans le formulaire pour afficher un message clair à l'utilisateur
au lieu d'une erreur SQLite brute, et éviter un aller-retour inutile vers
la base.

## Q5.3

a) Le résultat brut est une List<Map<String, Object?>> ; chaque ligne est
une Map {nom_colonne: valeur}, avec disponible = 1/0 et date_ajout en texte.
b) Modifier une ligne lève une erreur "read-only" : les Map renvoyées par
sqflite sont non modifiables. On crée un nouvel objet à la place.

## Q5.4

lireProduitParId renvoie Produit? car l'id demandé peut ne pas exister
(lireProduitParId(999) retourne null).

## Q5.7

Avec future: \_dao.lireProduits() directement dans le FutureBuilder, la requête
est relancée à chaque reconstruction du widget (rotation, clavier, setState
du parent...). Il faut créer le Future une seule fois dans initState.

## Q5.11

On passe seulement l'id et on relit la base pour afficher des données à jour :
un objet passé en paramètre peut devenir périmé si le produit est modifié
ailleurs (formulaire, ajustement de stock).

## Q6.2

Les TextEditingController doivent être libérés dans dispose() : ils gardent
des écouteurs et de la mémoire. Sans dispose(), il y aurait des fuites de
mémoire quand l'écran est fermé.

## Q6.9

Un UPDATE sans WHERE modifie TOUTES les lignes de la table (tous les prix
passent à 1). Leçon : toujours mettre un WHERE sur l'id, et tester d'abord
avec un SELECT.

## Q6.10

Tous les champs sont final : un objet est immuable, on ne peut pas modifier
un champ. copyWith crée une nouvelle copie avec seulement les champs changés
(l'id et la date d'ajout sont conservés).

## Q6.12

modifierProduit retourne 1 (une ligne modifiée). Si l'id n'existait pas, il
retournerait 0 : aucune ligne ne correspond au WHERE.

## Q6.16

Si la quantité vaut 0 et qu'on clique sur « − », ajusterQuantite retourne 0 :
la condition `quantite + ? >= 0` du WHERE est fausse, aucune ligne n'est
modifiée. Le calcul `quantite + ?` fait par SQLite est plus sûr que lire en
Dart puis réécrire : l'opération est atomique, sans risque qu'une autre
modification ait changé la valeur entre la lecture et l'écriture, et la
contrainte est vérifiée dans la même requête.
