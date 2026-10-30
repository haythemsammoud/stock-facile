-- Q1.5.1
SELECT * FROM produits;
-- Q1.5.2
SELECT * FROM produits WHERE quantite = 0;
-- Q1.5.3
SELECT * FROM produits ORDER BY prix DESC;
-- Q1.5.4
SELECT p.nom AS produit, c.nom AS categorie
FROM produits p INNER JOIN categories c ON c.id = p.categorie_id;
-- Q1.5.5
SELECT c.nom, COUNT(p.id) AS nb
FROM categories c LEFT JOIN produits p ON p.categorie_id = c.id
GROUP BY c.id;
-- Q1.5.6
SELECT SUM(prix * quantite) AS valeur_stock FROM produits;


1.51
1	Huile d'olive 1 L	18.5	24	1	2026-10-01T09:00:00	1
2	Couscous moyen 1 kg	2.3	40	1	2026-10-01T09:05:00	1
3	Eau minérale 1,5 L	0.85	120	1	2026-10-02T10:00:00	2
4	Jus d'orange 1 L	3.2	0	0	2026-10-02T10:10:00	2
5	Savon de Marseille	2.9	15	1	2026-10-03T11:00:00	3
6	Cahier 96 pages	1.6	60	1	2026-10-04T08:30:00	4
7	Huile d'olive 1 L	18.5	24	1	2026-10-01T09:00:00	1
8	Couscous moyen 1 kg	2.3	40	1	2026-10-01T09:05:00	1
9	Eau minérale 1,5 L	0.85	120	1	2026-10-02T10:00:00	2
10	Jus d'orange 1 L	3.2	0	0	2026-10-02T10:10:00	2
11	Savon de Marseille	2.9	15	1	2026-10-03T11:00:00	3
12	Cahier 96 pages	1.6	60	1	2026-10-04T08:30:00	4

1.5.2
4	Jus d'orange 1 L	3.2	0	0	2026-10-02T10:10:00	2
10	Jus d'orange 1 L	3.2	0	0	2026-10-02T10:10:00	2


1.5.3
1	Huile d'olive 1 L	18.5	24	1	2026-10-01T09:00:00	1
7	Huile d'olive 1 L	18.5	24	1	2026-10-01T09:00:00	1
4	Jus d'orange 1 L	3.2	0	0	2026-10-02T10:10:00	2
10	Jus d'orange 1 L	3.2	0	0	2026-10-02T10:10:00	2
5	Savon de Marseille	2.9	15	1	2026-10-03T11:00:00	3
11	Savon de Marseille	2.9	15	1	2026-10-03T11:00:00	3
2	Couscous moyen 1 kg	2.3	40	1	2026-10-01T09:05:00	1
8	Couscous moyen 1 kg	2.3	40	1	2026-10-01T09:05:00	1
6	Cahier 96 pages	1.6	60	1	2026-10-04T08:30:00	4
12	Cahier 96 pages	1.6	60	1	2026-10-04T08:30:00	4
3	Eau minérale 1,5 L	0.85	120	1	2026-10-02T10:00:00	2
9	Eau minérale 1,5 L	0.85	120	1	2026-10-02T10:00:00	2

1.5.4
Huile d'olive 1 L	Alimentation
Couscous moyen 1 kg	Alimentation
Eau minérale 1,5 L	Boissons
Jus d'orange 1 L	Boissons
Savon de Marseille	Hygiène
Cahier 96 pages	Papeterie
Huile d'olive 1 L	Alimentation
Couscous moyen 1 kg	Alimentation
Eau minérale 1,5 L	Boissons
Jus d'orange 1 L	Boissons
Savon de Marseille	Hygiène
Cahier 96 pages	Papeterie

1.5.5
Alimentation	4
Boissons	4
Hygiène	2
Papeterie	2

1.5.6
1555.0