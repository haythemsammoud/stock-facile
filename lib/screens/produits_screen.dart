class _ProduitsScreenState extends State<ProduitsScreen> {
  final ProduitDao _dao = ProduitDao();
  late Future<List<Produit>> _futurProduits;

  @override
  void initState() {
    super.initState();
    _futurProduits = _dao.lireProduits();
  }

  void _rafraichir() {
    setState(() {
      _futurProduits = _dao.lireProduits();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Produit>>(
      future: _futurProduits,
      builder: (context, snapshot) {
        // 1. Chargement en cours     → CircularProgressIndicator centré
        // 2. Erreur                  → message rouge avec snapshot.error
        // 3. Liste vide              → icône + texte « Aucun produit »
        // 4. Données reçues          → ListView.builder de ProduitTile
        // À compléter (Q5.6)
      },
    );
  }
}