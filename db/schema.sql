CREATE TABLE IF NOT EXISTS Magasins (
  id_magasin INTEGER PRIMARY KEY,
  ville TEXT,
  nombre_salaries INTEGER
);

CREATE TABLE IF NOT EXISTS Produits (
  id_reference_produit TEXT PRIMARY KEY,
  nom TEXT,
  prix REAL,
  stock INTEGER
);

CREATE TABLE IF NOT EXISTS Ventes (
  date TEXT,
  id_reference_produit TEXT,
  quantite INTEGER,
  id_magasin INTEGER,
  PRIMARY KEY (date, id_reference_produit, id_magasin),
  FOREIGN KEY(id_reference_produit) REFERENCES Produits(id_reference_produit),
  FOREIGN KEY(id_magasin) REFERENCES Magasins(id_magasin)
);

--
-- Vue CA Total
--
CREATE VIEW IF NOT EXISTS Vue_ChiffreAffairesTotal AS
SELECT SUM(v.quantite * p.prix) AS total_ca
FROM Ventes v
JOIN Produits p ON v.id_reference_produit = p.id_reference_produit;

--
-- Vue Ventes par produit
--
CREATE VIEW IF NOT EXISTS Vue_VentesParProduit AS
SELECT
    p.id_reference_produit AS id_produit,
    p.nom AS nom_produit,
    SUM(v.quantite) AS total_quantite,
    SUM(v.quantite * p.prix) AS total_ca
FROM Ventes v
JOIN Produits p ON v.id_reference_produit = p.id_reference_produit
GROUP BY p.id_reference_produit, p.nom;

--
-- Vue Ventes par ville
--
CREATE VIEW IF NOT EXISTS Vue_VentesParVille AS
SELECT
    m.ville,
    SUM(v.quantite) AS total_quantite,
    SUM(v.quantite * p.prix) AS total_ca
FROM Ventes v
JOIN Magasins m ON v.id_magasin = m.id_magasin
JOIN Produits p ON v.id_reference_produit = p.id_reference_produit
GROUP BY m.ville;
